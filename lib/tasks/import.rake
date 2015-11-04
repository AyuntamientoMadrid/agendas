namespace :madrid do

  task :import => :environment do

    desc 'Preceso de importación'

    uweb_api = UwebApi.new
    directory_api = DirectoryApi.new

    # p 'Importing users...'
    # get_users(uweb_api, Rails.application.secrets.uweb_api_users_key).each do |mc|
    #   user = User.create_from_uweb('user',get_user(uweb_api, mc['CLAVE_IND']))
    #   p 'Creating user '+user.full_name
    #   user.save
    # end

    # p 'Importing admin users...'
    # get_users(uweb_api, Rails.application.secrets.uweb_api_admins_key).each do |mc|
    #   user = User.create_from_uweb('admin',get_user(uweb_api, mc['CLAVE_IND']))
    #   p 'Creating admin '+user.full_name
    #   user.save
    # end


    p 'Importing holders...'
    get_users(uweb_api,Rails.application.secrets.uweb_api_holders_key).each do |mc|
      data = get_user(uweb_api, mc['CLAVE_IND'])
      holder = Holder.create_from_uweb(data)
      p 'Creating holder '+holder.full_name + ' con unidad ' + data['COD_UNIDAD'].to_s

      units = get_units(directory_api, data['COD_UNIDAD'])
      p units
      # Create areas tree



      # Create position
      # Save holder


      #response = directory_api.client.call(:buscar_dependencias, message: api.request({cod_organico: data['COD_UNIDAD']})).body
      #pata = response[:buscar_dependencias_response][:buscar_dependencias_return]
      #p pata
    end

  end

  def get_users(uweb_api, profileKey)
    data = uweb_api.data(:get_users_profile_application_list,{profileKey: profileKey})
    Hash.from_xml(data)['USUARIOS']['USUARIO']
  end

  def get_user(uweb_api, userKey)
    data = uweb_api.data(:get_user_data, {userKey: userKey})
    Hash.from_xml(data)['USUARIO']
  end

  def get_units(directory_api, codOrganico)
    data = directory_api.data(:buscar_dependencias, {codOrganico: codOrganico})
    Hash.from_xml(data)['UNIDADES_ORGANIZATIVAS']
  end

end
