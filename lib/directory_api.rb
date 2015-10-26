class DirectoryApi

  attr_accessor :client, :request

  def client
    @client = Savon.client(wsdl: Rails.application.secrets.uweb_api_endpoint)
  end

  def response(method)
    client.call(method, message: request).body if end_point_available?
  end

  def request(user_key)
    { request:
      { appKey: Rails.application.secrets.uweb_api_app_key,
        userKey: user_key
      }
    }
  end

  def data(method)
    response(method)[(method.to_s+'_response').to_sym][(method.to_s+'_return').to_sym]
  end

  def end_point_available?
    Rails.env.staging? || Rails.env.preproduction? || Rails.env.production? || Rails.env.development?
  end

end
