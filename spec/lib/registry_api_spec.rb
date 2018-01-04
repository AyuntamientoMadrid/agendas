require 'spec_helper'
require 'savon'
require 'savon/mock/spec_helper'

describe RegistryApi do
  include Savon::SpecHelper

  before(:all) { savon.mock!   }
  after(:all)  { savon.unmock! }

  describe "#client" do
    it "Should return new SavonClient instance for defined wsdl" do
      client =  RegistryApi.new.client

      expect(client.class).to eq(Savon::Client)
    end
  end

  describe "#get_annotation_document" do

    it "return error response when application name has wrong name" do
      message = { Aplicacion: "incorrect_name", CodigoDocumento: "0901ffd68013878f",
                  Sentido: "E", NumAnotacion: "AAAA20170000990" }
      soap_fault = File.read("spec/fixtures/registry_api/not_authorized_response.xml")
      response = { code: 500, headers: {}, body: soap_fault }
      savon.expects(:get_documento_anotacion).with(message: message).returns(response)

      service = RegistryApi.new

      expect{ service.get_documento_anotacion(message) }.to raise_exception(Savon::HTTPError)
    end

    it "return error response when annotation number is wrong" do
      message = { Aplicacion: "incorrect_name", CodigoDocumento: "0901ffd68013878f",
                  Sentido: "E", NumAnotacion: "AAAA20170000990" }
      soap_fault = File.read("spec/fixtures/registry_api/bad_annotation_number_response.xml")
      response = { code: 500, headers: {}, body: soap_fault }
      savon.expects(:get_documento_anotacion).with(message: message).returns(response)

      service = RegistryApi.new

      expect{ service.get_documento_anotacion(message) }.to raise_exception(Savon::HTTPError)
    end

    it "return error response when document not found by given CodigoDocumento" do
      message = { Aplicacion: "incorrect_name", CodigoDocumento: "0901ffd68013878f",
                  Sentido: "E", NumAnotacion: "AAAA20170000990" }
      soap_fault = File.read("spec/fixtures/registry_api/bad_annotation_number_response.xml")
      response = { code: 500, headers: {}, body: soap_fault }
      savon.expects(:get_documento_anotacion).with(message: message).returns(response)

      service = RegistryApi.new

      expect{ service.get_documento_anotacion(message) }.to raise_exception(Savon::HTTPError)
    end

    it "return successful response from remote registry when " do
      message = { Aplicacion: "correct_name", CodigoDocumento: "0901ffd68013878f",
                  Sentido: "E", NumAnotacion: "AAAA20170000990" }
      fixture = File.read("spec/fixtures/registry_api/successful_response.xml")
      savon.expects(:get_documento_anotacion).with(message: message).returns(fixture)

      service = RegistryApi.new

      response = service.get_documento_anotacion(message)
      expect(response).to be_successful
    end

  end

end
