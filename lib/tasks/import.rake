namespace :madrid do

  task :import => :environment do

    desc 'Preceso de importación'

    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new


    desc 'Importing Users...'
    get_users(uweb_api, Rails.application.secrets.uweb_api_users_key).each do |mc|
      user = User.create_from_uweb('user',get_user(uweb_api, mc['CLAVE_IND']))
      user.save
    end

    desc 'Importing Holders...'
    get_users(uweb_api,Rails.application.secrets.uweb_api_holders_key).each do |mc|
      holder = Holder.create_from_uweb(get_user(uweb_api, mc['CLAVE_IND']))
      # Create areas tree
      # Create position
      # Save holder


      #response = directory_api.client.call(:buscar_dependencias, message: api.request({cod_organico: data['COD_UNIDAD']})).body
      #pata = response[:buscar_dependencias_response][:buscar_dependencias_return]
      #p pata
    end

  end

  def get_users(uweb_api, profileKey)
    data = uweb_api.data(:get_users_profile_application_list,{profileKey: Rails.application.secrets.uweb_api_users_key})
    Hash.from_xml(data)['USUARIOS']['USUARIO']
  end

  def get_user(uweb_api, userKey)
    data = uweb_api.data(:get_user_data, {userKey: userKey})
    Hash.from_xml(data)['USUARIO']
  end

end
