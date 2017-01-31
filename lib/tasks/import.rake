namespace :madrid do

  task :import => :environment do

    desc 'Proceso de importación'

    @uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    p 'Importing users...'
    uweb_get_users('uweb_api_users_key').each do |mc|
      user = user_create('user', mc)
      p 'Creating user '+user.full_name
      user.save
    end
    p 'Finished importing users...'

    p 'Importing admin users...'
    uweb_get_users('uweb_api_admins_key').each do |mc|
      user = user_create('admin', mc)
      p 'Creating admin '+user.full_name
      user.save
    end
    p 'Finished importing admin users...'


    p 'Importing holders...'
    uweb_get_users('uweb_api_holders_key').each do |mc|
      data = uweb_api.get_user(mc['CLAVE_IND'])
      holder = Holder.create_from_uweb(data)
      if !data['COD_UNIDAD'].nil?
        units = directory_api.get_units(data['COD_UNIDAD'])
        if !units.nil?
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
      if !(holder.try!(:positions).try!(:current).try!(:first).try!(:title) == data['CARGO'] && holder.try!(:positions).try!(:current).try!(:first).try!(:area) == area)
        holder.current_position.finalize.save if holder.current_position.present?
        position = Position.create(title: data['CARGO'], area: area, from: Time.now)
        holder.positions << position
      end
      if holder.valid?
        holder.save
      else
        p 'Something unexpected'
        p holder
        p holder.errors
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
