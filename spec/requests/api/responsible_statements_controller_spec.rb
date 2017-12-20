require 'spec_helper'
require 'savon'

describe Api::ResponsibleStatementsController do

  let!(:application_base) { "http://application" }

  before do
    HTTPI.adapter = :rack
    HTTPI::Adapter::Rack.mount 'application', Agendas::Application
  end

  describe "inicioExpediente" do

    describe "Authentication" do
      it "Should deny access when no username defined" do
        skip "Until authentication reactivation"
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path,
                  wsse_auth: ["", "password"])

        expect { client.call(:inicio_expediente, message: {}) }.to raise_error(Savon::SOAPFault, '(Server) Unauthorized')
      end

      it "Should deny access when no password defined" do
        skip "Until authentication reactivation"
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path,
                  wsse_auth: ["username", ""])

        expect { client.call(:inicio_expediente, message: {}) }.to raise_error(Savon::SOAPFault, '(Server) Unauthorized')
      end

      it "Should deny access when bad usernmae and password supplied" do
        skip "Until authentication reactivation"
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path,
                  wsse_auth: ["other_username", "bad_password"])

        expect { client.call(:inicio_expediente, message: {}) }.to raise_error(Savon::SOAPFault, '(Server) Unauthorized')
      end

      it "Should accept conections when password and user well defined" do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path,
                  wsse_auth: ["username", "password"])

        expect { client.call(:inicio_expediente, message: {}) }.not_to raise_error
      end
    end

    it "Should return error when codTipoExpediente is not provided" do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path,
                wsse_auth: ["username", "password"])

      response = client.call(:inicio_expediente, message: {})

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "codTipoExpediente cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to  be_blank
    end

    it "Should return error when xmlDatosEntrada is not provided" do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path,
                wsse_auth: ["username", "password"])

      response = client.call(:inicio_expediente,
                             message: { codTipoExpediente: "1234" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "xmlDatosEntrada cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    it "Should return error when usuario is not provided" do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path,
                wsse_auth: ["username", "password"])

      response = client.call(:inicio_expediente,
                             message: {
                              codTipoExpediente: "1234",
                              xmlDatosEntrada: "sample" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "usuario cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    it "Should return success when organization could be created" do
      skip "until implementation"
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path,
                wsse_auth: ["username", "password"])

      response = client.call(:inicio_expediente,
                             message: {
                              codTipoExpediente: "1234",
                              xmlDatosEntrada: File.read("spec/fixtures/newResponsibleStatement.xml"),
                              usuario: "WFORM" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "usuario cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end
  end

end