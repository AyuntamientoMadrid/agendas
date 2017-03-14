namespace :madrid do

  task :import => :environment do

    desc 'Proceso de importación'

    @uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    p 'Importing users...'
    uweb_get_users('uweb_api_users_key').each do |mc|
      user = user_create('user', mc)
      #p 'Creating user '+user.full_name
      user.save
    end
    p 'Finished importing users...'

    p 'Importing admin users...'
    uweb_get_users('uweb_api_admins_key').each do |mc|
      user = user_create('admin', mc)
      #p 'Creating admin '+user.full_name
      user.save
    end
    p 'Finished importing admin users...'

    p 'Importing holders...'
    uweb_get_users('uweb_api_holders_key').each do |mc|
      begin
        data = @uweb_api.get_user(mc['CLAVE_IND'])
      rescue => e
        puts "Holder with uweb_key #{@uweb_api.get_user(mc['CLAVE_IND'])} exception"
        puts e.message            # Test de excepción
        puts e.backtrace.inspect
      end

      if e.nil?

        holder = Holder.create_from_uweb(data)

        unless data['COD_UNIDAD'].nil?
          units = directory_api.get_units(data['COD_UNIDAD'])

          unless units.nil?
            unidad = units['UNIDAD_ORGANIZATIVA']
            if unidad.kind_of?(Array)
              unit = unidad[0]['ID_UNIDAD']
            else
              unit = unidad['ID_UNIDAD']
            end
            directory_api.create_tree(unit)
          end
        end

        # Comprobamos si el cargo y el area coinciden
        area = Area.find_by(internal_id: unit)

        holder.positions.each do |position|
          begin
            position.finalize.save! if position.to.nil?
          rescue => e
            p 'Error at finalize position'
          end
        end

        #Comprobamos si existe cargo, hay algun caso eliminado por GI sin cargo
        if data['CARGO'].present?
          begin
            position = Position.find_or_create_by(title: data['CARGO'], area: area, holder: holder)
            position.holder_id = holder.id
            position.to = nil unless data['BAJA_LOGICA'] == '1'
            position.from = Time.now if position.from.nil?

            position.save!
            holder.positions << position
          rescue => e
            p 'Error at save position'
          end
        end

        if holder.valid?
          begin
            holder.save!
          rescue => e
            p 'Error at save holder'
          end
        else
          p 'Something unexpected'
          p holder
          p holder.errors
        end
      end
    end
    p 'Finished importing holders...'
  end

  private

  def uweb_get_users(method)
    @uweb_api.get_users(Rails.application.secrets.send(method))
  end
  def user_create(type, mc)
    User.create_from_uweb(type,@uweb_api.get_user(mc['CLAVE_IND']))
  end

end
