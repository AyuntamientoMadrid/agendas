class UwebApi < MadridApi

  def client
    @client = Savon.client(wsdl: Rails.application.secrets.uweb_api_endpoint)
  end

  def request(params)
    h=Hash.new
    h[:appKey] = Rails.application.secrets.uweb_api_app_key
    params.each do |k,v|
      h[k] = v
    end
    {request: h}
  end

  def get_users(profileKey)
    data = data(:get_users_profile_application_list,{profileKey: profileKey})
    Hash.from_xml(data)['USUARIOS']['USUARIO']
  end

  def get_user(userKey)
    data = data(:get_user_data, {userKey: userKey})
    Hash.from_xml(data)['USUARIO']
  end

end
