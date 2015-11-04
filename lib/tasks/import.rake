namespace :madrid do



  task :import => :environment do

    desc 'Preceso de importación'

    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new


    desc 'Usuarios'
    import_users(uweb_api)

    desc 'Holders'
    import_holders(uweb_api)



  end

  def import_users(uweb_api)
    data = uweb_api.data(:get_users_profile_application_list,{profileKey: Rails.application.secrets.uweb_api_users_key})
    Hash.from_xml(data)['USUARIOS']['USUARIO'].each do |mc|
      user_data = uweb_api.data(:get_user_data, {userKey: mc['CLAVE_IND']})
      User.create_from_uweb('user',Hash.from_xml(user_data)['USUARIO'])
    end
  end

  def import_holders(uweb_api)
    data = uweb_api.data(:get_users_profile_application_list,{profileKey: Rails.application.secrets.uweb_api_holders_key})
    Hash.from_xml(data)['USUARIOS']['USUARIO'].each do |mc|
      user_data = uweb_api.data(:get_user_data, {userKey: mc['CLAVE_IND']})
      Holder.create_from_uweb(Hash.from_xml(user_data)['USUARIO'])
    end
  end

end
