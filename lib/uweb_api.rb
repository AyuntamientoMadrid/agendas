class UwebApi

  attr_accessor :client, :request

  def client
    @client = Savon.client(wsdl: Rails.application.secrets.uweb_api_endpoint)
  end

  def response(method,params)
    client.call(method, message: request(params)).body if end_point_available?
  end

  def request(params)
    h=Hash.new
    h[:appKey] = Rails.application.secrets.uweb_api_app_key
    params.each do |k,v|
      h[k] = v
    end
    {request: h}
  end

  def data(method,params)
    response(method,params)[(method.to_s+'_response').to_sym][(method.to_s+'_return').to_sym]
  end

  def end_point_available?
    Rails.env.staging? || Rails.env.preproduction? || Rails.env.production? || Rails.env.development?
  end

end
