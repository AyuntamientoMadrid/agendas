namespace :madrid do

  task :import => :environment do

    desc 'Preceso de importación'

    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    p 'Importing users...'
    uweb_api.get_users(Rails.application.secrets.uweb_api_users_key).each do |mc|
      user = User.create_from_uweb('user',uweb_api.get_user(mc['CLAVE_IND']))
      p 'Creating user '+user.full_name
      user.save
    end

    p 'Importing admin users...'
    uweb_api.get_users(Rails.application.secrets.uweb_api_admins_key).each do |mc|
      user = User.create_from_uweb('admin',uweb_api.get_user(mc['CLAVE_IND']))
      p 'Creating admin '+user.full_name
      user.save
    end


    p 'Importing holders...'
    uweb_api.get_users(Rails.application.secrets.uweb_api_holders_key).each do |mc|
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
      # Si coinciden lo dejamos tal cual y salvamos holder
      area = Area.find_by(internal_id: unit)
        if !(holder.try!(:positions).try!(:current).try!(:first).try!(:title) == data['CARGO'] && holder.try!(:positions).try!(:current).try!(:first).try!(:area) == area)
          # TODO: Dar por terminado el cargo actual
          position = Position.create(title: data['CARGO'], area: area, from: Time.now)
          holder.positions << position
        end
      if holder.valid?
        holder.save
      else
        p holder.errors
      end
    end
  end

end
