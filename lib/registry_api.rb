class RegistryApi

  attr_accessor :client

  def initialize
    @client = Savon.client(wsdl: Rails.application.secrets.registry_api_endpoint,
                           encoding: 'ISO-8859-1')
  end

  def get_documento_anotacion(message)
    # # params = { Aplicacion: application_name, CodigoDocumento: document_code,
    # #            Sentido: sense, NumAnotacion: annotation_number }
    # data = data(:get_documento_anotacion, message)
    # data = data.encode('ISO-8859-1')
    # Hash.from_xml(data)['DOCUMENTO']
    response = @client.call(:get_documento_anotacion, message: message)
    response.to_xml
    #message: { Aplicacion: “RLOBBIES”, CodigoDocumento: “0901ffd680138b07", Sentido: “E”, NumAnotacion: “AAAA20170001003" }
  end

end
