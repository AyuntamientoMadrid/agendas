require 'spec_helper'
require 'savon'

describe Api::ResponsibleStatementsController do

  let!(:application_base) { "http://application" }

  before do
    HTTPI.adapter = :rack
    HTTPI::Adapter::Rack.mount 'application', Agendas::Application
    @no_record = create(:registered_lobby, name: "Ninguno")
    @general   = create(:registered_lobby, name: "Generalidad catalunya")
    @cnmc      = create(:registered_lobby, name: "CNMC")
    @ue        = create(:registered_lobby, name: "Unión Europea")
    @other     = create(:registered_lobby, name: "Otro")
    @category_emp = create(:category, name: "Empresas")
    @category_pro = create(:category, name: "Consultoría profesional y despachos de abogados")
  end

  describe "inicioExpediente" do

    it "Should return error when codTipoExpdiente is not provided", :wsdl do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente, message: {})

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "codTipoExpdiente cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to  be_blank
    end

    it "Should return error when xmlDatosEntrada is not provided", :wsdl do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente,
                             message: { codTipoExpdiente: "1234" })

      body = response.body[:inicio_expediente_response]
      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "xmlDatosEntrada cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    it "Should return error when usuario is not provided", :wsdl do
      client = Savon::Client.new(
                wsdl: application_base + api_responsible_statements_wsdl_path)

      response = client.call(:inicio_expediente,
                             message: {
                              codTipoExpdiente: "1234",
                              xmlDatosEntrada: "sample" })

      body = response.body[:inicio_expediente_response]

      expect(body[:cod_retorno]).to eq '0'
      expect(body[:desc_error]).to  eq "usuario cannot be blank"
      expect(body[:id_expediente]).to be_blank
      expect(body[:ref_expediente]).to be_blank
    end

    describe "Create responsible statement" do

      it "Should return success when organization could be created", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000990", "0901ffd68013878d", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000990", "0901ffd68013878e", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000990", "0901ffd68013878f", "newResponsibleStatement_pdf_attachment_2.xml")
        set_attachment_stub("20170000990", "0901ffd680138b07", "newResponsibleStatement_png_attachment.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_1.xml"),
                                usuario: "WFORM" })

        body = response.body[:inicio_expediente_response]
        expect(body[:cod_retorno]).to eq nil
        expect(body[:desc_error]).to  eq "OK"
        expect(body[:id_expediente]).to eq "idExpediente"
        expect(body[:ref_expediente]).to eq "refExpediente"
      end

      ########DECLARACIÓN RESPONSABLE########
      # DATOS 1: DATOS IDENTIFICATIVOS DE QUIEN APARECERA COMO INSCRITO EN EL REGISTRO
      # DATOS 2: DATOS DE LA PERSONA O ENTIDAD REPRESENTANTE
      # DATOS 3: PERSONA FISICA DE CONTACTO
      # DATOS 4: DATOS DE QUIEN VA A EJERCER LA ACTIVIDAD DE LOBBY POR CUENTA PROPIA (own_lobby_activity)
      # DATOS 5: DATOS PERSONAS O ENTIDADES SIN PERSONALIDAD A QUIENES SE VA A REPRESENTAR (foreign_lobby_activity)
      # DATOS 6: ARCHIVOS ADJUNTOS

      it "Should create organization with all data_1 fields and own_lobby_activity", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000990", "0901ffd68013878d", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000990", "0901ffd68013878e", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000990", "0901ffd68013878f", "newResponsibleStatement_pdf_attachment_2.xml")
        set_attachment_stub("20170000990", "0901ffd680138b07", "newResponsibleStatement_png_attachment.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_1.xml"),
                                usuario: "WFORM" })

        organization = Organization.last
        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170000990"
        expect(organization.identifier).to eq "50048658Z"
        expect(organization.name).to eq "JOSE ANTONIO"
        expect(organization.first_surname).to eq "IZQUIERDO"
        expect(organization.second_surname).to eq "GARCIA"
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "MADRID"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "SANLUCAR DE BARRAMEDA"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "8"
        expect(organization.gateway).to eq "PORTAL"
        expect(organization.stairs).to eq "IZQ"
        expect(organization.floor).to eq "2"
        expect(organization.door).to eq "4"
        expect(organization.postal_code).to eq "28033"
        expect(organization.email).to eq "izquierdoja@madrid.es"
        expect(organization.phones).to eq "600123123, 915625326"
        expect(organization.category).to eq @category_emp
        expect(organization.description).to eq "finalidad"
        expect(organization.web).to eq "www.web.es"
        expect(organization.registered_lobbies).to eq [@no_record]

        #DATA_2
        expect(organization.legal_representant).to eq nil

        #DATA_3
        #expect(organization.user.tipo de documento).to eq
        expect(organization.user.identifier).to eq "43138882G"
        expect(organization.user.first_name).to eq "user_name"
        expect(organization.user.last_name).to eq "user_apellido_1 user_apellido_2"
        expect(organization.user.email).to eq "email@email.com"
        expect(organization.user.phones).to eq "600123123, 971123123"

        #DATA_4
        expect(organization.own_lobby_activity).to eq true
        expect(organization.fiscal_year).to eq 2017
        expect(organization.range_fund).to eq "range_1"
        expect(organization.contract).to eq false
        expect(organization.subvention).to eq false

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq false
        expect(organization.represented_entities).to eq []

        #DATA_6
        expect(organization.attachments.count).to eq 2
      end

      it "Should create organization with own_lobby_activity and foreign_lobby_activity", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000995", "0901ffd680138ac0", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000995", "0901ffd680138ac1", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000995", "0901ffd680138ac2", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_2.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170000995"
        expect(organization.identifier).to eq "12755026P"
        expect(organization.name).to eq "JOAQUÍN"
        expect(organization.first_surname).to eq "MESEGUER"
        expect(organization.second_surname).to eq "YEBRA"
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "Madrid"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "Alcalá"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "45"
        expect(organization.gateway).to eq nil
        expect(organization.stairs).to eq nil
        expect(organization.floor).to eq nil
        expect(organization.door).to eq nil
        expect(organization.postal_code).to eq "28014"
        expect(organization.email).to eq "mesegueryj@madrid.es"
        expect(organization.phones).to eq nil
        expect(organization.category).to eq @category_emp
        expect(organization.description).to eq "influir en la normativa sobre transparencia"
        expect(organization.web).to eq "wwww.transparentes.org"
        expect(organization.registered_lobbies).to eq [@no_record]
        expect(organization.check_email).to eq true
        expect(organization.check_sms).to eq false

        #DATA_2
        expect(organization.legal_representant).to eq nil

        #DATA_3
        expect(organization.user.identifier).to eq "12755026P"
        expect(organization.user.first_name).to eq "JOAQUÍN"
        expect(organization.user.last_name).to eq "MESEGUER YEBRA"
        expect(organization.user.email).to eq "mesegueryj@madrid.es"
        expect(organization.user.phones).to eq "650901852"

        #DATA_4
        expect(organization.own_lobby_activity).to eq true
        expect(organization.fiscal_year).to eq 2017
        expect(organization.range_fund).to eq "range_2"
        expect(organization.contract).to eq false
        expect(organization.subvention).to eq false

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq true
        expect(organization.represented_entities.count).to eq 1
        expect(organization.represented_entities.first.identifier).to eq "530700265"
        expect(organization.represented_entities.first.name).to eq "Tela Marinera"
        expect(organization.represented_entities.first.first_surname).to eq nil
        expect(organization.represented_entities.first.second_surname).to eq nil
        expect(organization.represented_entities.first.from).to eq Date.parse("27/12/2017")
        expect(organization.represented_entities.first.to).to eq nil
        expect(organization.represented_entities.first.organization_id).to eq organization.id
        expect(organization.represented_entities.first.range_fund).to eq "range_1"
        expect(organization.represented_entities.first.contract).to eq false
        expect(organization.represented_entities.first.subvention).to eq false

        #DATA_6
        expect(organization.attachments.count).to eq 1
      end

      it "Should create organization with own_lobby_activity and multiple registered_lobbies", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000996", "0901ffd680138ac3", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac4", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac5", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_3.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170000996"
        expect(organization.identifier).to eq "70572650W"
        expect(organization.name).to eq "HONORIO ENRIQUE"
        expect(organization.first_surname).to eq "CRESPO"
        expect(organization.second_surname).to eq "DÍAZ-ALEJO"
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "MADRID"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "ALCALA"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "45"
        expect(organization.gateway).to eq nil
        expect(organization.stairs).to eq nil
        expect(organization.floor).to eq nil
        expect(organization.door).to eq nil
        expect(organization.postal_code).to eq "28014"
        expect(organization.email).to eq "crespodhe@madrid.es"
        expect(organization.phones).to eq "915133100"
        expect(organization.category).to eq @category_emp
        expect(organization.description).to eq "Reuniones con el Ayuntamiento, Distritos, Áreas de Gobierno, para luchar porque el Ajedrez se convierta en un deporte potenciado por el Ayuntamiento de Madrid, debido a los grandes valores que tiene la práctica de este deporte.Linea 3 Línea 4 Línea 5 y última."
        expect(organization.web).to eq "www.madrid.es"
        expect(organization.registered_lobbies).to eq [@general, @cnmc, @other]
        expect(organization.check_email).to eq true
        expect(organization.check_sms).to eq true

        #DATA_2
        expect(organization.legal_representant).to eq nil

        #DATA_3
        #expect(organization.user.tipo de documento).to eq N
        expect(organization.user.identifier).to eq "70572650w"
        expect(organization.user.first_name).to eq "HONORIO ENRIQUE"
        expect(organization.user.last_name).to eq "CRESPO DIAZ-ALEJO"
        expect(organization.user.email).to eq "old@email.com"
        expect(organization.user.phones).to eq "915133100"

        #DATA_4
        expect(organization.own_lobby_activity).to eq true
        expect(organization.fiscal_year).to eq 2017
        expect(organization.range_fund).to eq "range_1"
        expect(organization.contract).to eq false
        expect(organization.subvention).to eq false

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq false
        expect(organization.represented_entities.count).to eq 0
        expect(organization.represented_entities).to eq []

        #DATA_6
        expect(organization.attachments.count).to eq 1
      end

      it "Should create organization with legal_representant and  own_lobby_activity and foreign_lobby_activity", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170001001", "0901ffd680138afc", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170001001", "0901ffd680138afd", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170001001", "0901ffd680138afe", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_4.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170001001"
        expect(organization.identifier).to eq "B82916651"
        expect(organization.name).to eq "Political Intelligence Spain, S.L"
        expect(organization.first_surname).to eq nil
        expect(organization.second_surname).to eq nil
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "MADRID"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "Claudio Coello"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "124"
        expect(organization.gateway).to eq nil
        expect(organization.stairs).to eq nil
        expect(organization.floor).to eq "2"
        expect(organization.door).to eq "A"
        expect(organization.postal_code).to eq "28006"
        expect(organization.email).to eq "POLITICAL@MADRID.ES"
        expect(organization.phones).to eq "444555666"
        expect(organization.category).to eq @category_pro
        expect(organization.description).to eq "Agencia de de public affairs especializada en políticas públicas y regulación en diversos sectores. Actividades específicas en relación con este Registro: Reuniones y contactos con el personal deL Ayuntamiento de Madrid la CNMC en representación de sus clientes. Participación en consultas públicas."
        expect(organization.web).to eq "www.political-intelligence.com/es"
        expect(organization.registered_lobbies).to eq [@general, @cnmc, @ue, @other]
        expect(organization.check_email).to eq true
        expect(organization.check_sms).to eq true

        #DATA_2
        expect(organization.legal_representant.identifier).to eq "70572650W"
        expect(organization.legal_representant.name).to eq "HONORIO ENRIQUE"
        expect(organization.legal_representant.first_surname).to eq "CRESPO"
        expect(organization.legal_representant.second_surname).to eq "DÍAZ-ALEJO"
        expect(organization.legal_representant.phones).to eq nil
        expect(organization.legal_representant.email).to eq "sse@se.com"
        expect(organization.legal_representant.organization_id).to eq organization.id

        #DATA_3
        #expect(organization.user.tipo de documento).to eq N
        expect(organization.user.identifier).to eq "70572650w"
        expect(organization.user.first_name).to eq "Enrique"
        expect(organization.user.last_name).to eq "Diaz"
        expect(organization.user.email).to eq "enrique@madrid.es"
        expect(organization.user.phones).to eq "666555444"

        #DATA_4
        expect(organization.own_lobby_activity).to eq true
        expect(organization.fiscal_year).to eq 2017
        expect(organization.range_fund).to eq "range_4"
        expect(organization.contract).to eq false
        expect(organization.subvention).to eq false

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq true
        expect(organization.represented_entities.count).to eq 3
        expect(organization.represented_entities.first.identifier).to eq "1234567L"
        expect(organization.represented_entities.first.name).to eq "REPSOL"
        expect(organization.represented_entities.first.first_surname).to eq nil
        expect(organization.represented_entities.first.second_surname).to eq nil
        expect(organization.represented_entities.first.from).to eq Date.parse("27/12/2017")
        expect(organization.represented_entities.first.to).to eq nil
        expect(organization.represented_entities.first.organization_id).to eq organization.id
        expect(organization.represented_entities.first.fiscal_year).to eq 2017
        expect(organization.represented_entities.first.range_fund).to eq "range_4"
        expect(organization.represented_entities.first.contract).to eq true
        expect(organization.represented_entities.first.subvention).to eq false

        expect(organization.represented_entities.second.identifier).to eq "12345678k"
        expect(organization.represented_entities.second.name).to eq "ENDESA"
        expect(organization.represented_entities.second.first_surname).to eq nil
        expect(organization.represented_entities.second.second_surname).to eq nil
        expect(organization.represented_entities.second.from).to eq Date.parse("27/12/2017")
        expect(organization.represented_entities.second.to).to eq nil
        expect(organization.represented_entities.second.organization_id).to eq organization.id
        expect(organization.represented_entities.second.fiscal_year).to eq 2016
        expect(organization.represented_entities.second.range_fund).to eq "range_3"
        expect(organization.represented_entities.second.contract).to eq false
        expect(organization.represented_entities.second.subvention).to eq true

        expect(organization.represented_entities.third.identifier).to eq "43333333z"
        expect(organization.represented_entities.third.name).to eq "GAS NATURAL"
        expect(organization.represented_entities.third.first_surname).to eq nil
        expect(organization.represented_entities.third.second_surname).to eq nil
        expect(organization.represented_entities.third.from).to eq Date.parse("04/08/2015")
        expect(organization.represented_entities.third.to).to eq nil
        expect(organization.represented_entities.third.organization_id).to eq organization.id
        expect(organization.represented_entities.third.fiscal_year).to eq 2015
        expect(organization.represented_entities.third.range_fund).to eq "range_4"
        expect(organization.represented_entities.third.contract).to eq true
        expect(organization.represented_entities.third.subvention).to eq false

        #DATA_6
        expect(organization.attachments.count).to eq 1
      end

      it "Should create organization with foreign_lobby_activity and attachment", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170001003", "0901ffd680138b02", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170001003", "0901ffd680138b03", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170001003", "0901ffd680138b08", "newResponsibleStatement_pdf_attachment_2.xml")
        set_attachment_stub("20170001003", "0901ffd680138b07", "newResponsibleStatement_png_attachment.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_5.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170001003"
        expect(organization.identifier).to eq "12755026P"
        expect(organization.name).to eq "JOAQUÍN"
        expect(organization.first_surname).to eq "MESEGUER"
        expect(organization.second_surname).to eq "YEBRA"
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "madrid"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "alcalá"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "45"
        expect(organization.gateway).to eq nil
        expect(organization.stairs).to eq nil
        expect(organization.floor).to eq nil
        expect(organization.door).to eq nil
        expect(organization.postal_code).to eq "28014"
        expect(organization.email).to eq "mesegueryj@madrid.es"
        expect(organization.phones).to eq "650901852"
        expect(organization.category).to eq @category_pro
        expect(organization.description).to eq "la transparencia"
        expect(organization.web).to eq nil
        expect(organization.registered_lobbies).to eq [@general]
        expect(organization.check_email).to eq true
        expect(organization.check_sms).to eq true

        #DATA_2
        expect(organization.legal_representant).to eq nil

        #DATA_3
        #expect(organization.user.tipo de documento).to eq N
        expect(organization.user.identifier).to eq "12755026P"
        expect(organization.user.first_name).to eq "JOAQUÍN"
        expect(organization.user.last_name).to eq "MESEGUER YEBRA"
        expect(organization.user.email).to eq "mesegueryj@madrid.es"
        expect(organization.user.phones).to eq "650901852"

        #DATA_4
        expect(organization.own_lobby_activity).to eq false
        expect(organization.fiscal_year).to eq nil
        expect(organization.range_fund).to eq nil
        expect(organization.contract).to eq false
        expect(organization.subvention).to eq false

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq true
        expect(organization.represented_entities.count).to eq 2
        expect(organization.represented_entities.first.identifier).to eq "12755028P"
        expect(organization.represented_entities.first.name).to eq "Pantoja Producciones"
        expect(organization.represented_entities.first.first_surname).to eq nil
        expect(organization.represented_entities.first.second_surname).to eq nil
        expect(organization.represented_entities.first.from).to eq Date.parse("19/12/2017")
        expect(organization.represented_entities.first.to).to eq nil
        expect(organization.represented_entities.first.organization_id).to eq organization.id
        expect(organization.represented_entities.first.fiscal_year).to eq nil
        expect(organization.represented_entities.first.range_fund).to eq nil
        expect(organization.represented_entities.first.contract).to eq false
        expect(organization.represented_entities.first.subvention).to eq false

        expect(organization.represented_entities.second.identifier).to eq "12755028P"
        expect(organization.represented_entities.second.name).to eq "Leonardo"
        expect(organization.represented_entities.second.first_surname).to eq "Dantés"
        expect(organization.represented_entities.second.second_surname).to eq nil
        expect(organization.represented_entities.second.from).to eq Date.parse("27/12/2017")
        expect(organization.represented_entities.second.to).to eq nil
        expect(organization.represented_entities.second.organization_id).to eq organization.id
        expect(organization.represented_entities.second.fiscal_year).to eq 2016
        expect(organization.represented_entities.second.range_fund).to eq "range_1"
        expect(organization.represented_entities.second.contract).to eq false
        expect(organization.represented_entities.second.subvention).to eq false

        #DATA_6
        expect(organization.attachments.count).to eq 2
      end

    end

    describe "Edit responsible statement" do

      before do
        create(:category, name: "Organizaciones empresariales")
      end

      it "Should return success when organization could be edit", :wsdl do
        create(:organization, identifier: "70572650W")
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000997", "0901ffd680138aed", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000997", "0901ffd680138aee", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000997", "0901ffd680138aef", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/editResponsibleStatement_1.xml"),
                                usuario: "WFORM" })

        body = response.body[:inicio_expediente_response]
        expect(body[:cod_retorno]).to eq nil
        expect(body[:desc_error]).to  eq "OK"
        expect(body[:id_expediente]).to eq "idExpediente"
        expect(body[:ref_expediente]).to eq "refExpediente"
      end

      it "Should update fields when send organization edit and create new user with welcome mail", :wsdl do
        ActionMailer::Base.deliveries = []
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000996", "0901ffd680138ac3", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac4", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac5", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_3.xml"),
                                usuario: "WFORM" })
        expect(ActionMailer::Base.deliveries.count).to eq(1) #UserMailer.welcome(organization.user).deliver_now
        organization = Organization.last
        expect(organization.attachments.count).to eq 1

        set_attachment_stub("20170000997", "0901ffd680138aed", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000997", "0901ffd680138aee", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000997", "0901ffd680138aef", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/editResponsibleStatement_1.xml"),
                                usuario: "WFORM" })

        expect(ActionMailer::Base.deliveries.count).to eq(3) #UserMailer.welcome(organization.user).deliver_now
                                                             #organization.send_update_mail
        organization = Organization.last

        #DATA_1
        #expect(organization.tipo de documento).to eq
        expect(organization.reference).to eq "20170000997"
        expect(organization.identifier).to eq "70572650W"
        expect(organization.name).to eq "HONORIO ENRIQUE"
        expect(organization.first_surname).to eq "CRESPO"
        expect(organization.second_surname).to eq "DÍAZ-ALEJO"
        expect(organization.country).to eq "ESPAÑA"
        expect(organization.province).to eq "MADRID"
        expect(organization.town).to eq "MADRID"
        expect(organization.address_type).to eq "CALLE"
        expect(organization.address).to eq "ALCALA"
        # expect(organization.number_type).to eq "Número"
        expect(organization.number).to eq "45"
        expect(organization.gateway).to eq nil
        expect(organization.stairs).to eq nil
        expect(organization.floor).to eq nil
        expect(organization.door).to eq nil
        expect(organization.postal_code).to eq "28014"
        expect(organization.email).to eq nil #updated
        expect(organization.phones).to eq nil #updated
        expect(organization.category).to eq @category_pro
        expect(organization.description).to eq nil #updated
        expect(organization.web).to eq nil #updated
        expect(organization.registered_lobbies).to eq [@no_record]
        expect(organization.check_email).to eq false #updated
        expect(organization.check_sms).to eq false #updated

        #DATA_2
        expect(organization.legal_representant).to eq nil

        #DATA_3
        #expect(organization.user.tipo de documento).to eq N
        expect(organization.user.identifier).to eq "70572650W"
        expect(organization.user.first_name).to eq "HONORIO ENRIQUE"
        expect(organization.user.last_name).to eq "CRESPO DÍAZ-ALEJO" #updated
        expect(organization.user.email).to eq "new@madrid.es"
        expect(organization.user.phones).to eq nil #updated

        #DATA_4
        expect(organization.own_lobby_activity).to eq true
        expect(organization.fiscal_year).to eq 2017
        expect(organization.range_fund).to eq "range_2" #updated
        expect(organization.contract).to eq true #updated
        expect(organization.subvention).to eq true #updated

        #DATA_5
        expect(organization.foreign_lobby_activity).to eq false
        expect(organization.represented_entities.count).to eq 0
        expect(organization.represented_entities).to eq []

        #DATA_6
        expect(organization.attachments.count).to eq 2
      end

      it "Should remove 1 represented entity and add new represented_entity", :wsdl do
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170001002", "0901ffd680138aff", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170001002", "0901ffd680138b00", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170001002", "0901ffd680138b01", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_6.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        expect(organization.represented_entities.count).to eq 2
        re_1 =  RepresentedEntity.where(identifier: "1").first
        expect(re_1.name).to eq "ENDESA"
        re_2 =  RepresentedEntity.where(identifier: "2").first
        expect(re_2.name).to eq "REPSOL"

        set_attachment_stub("20170001004", "0901ffd680138b09", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170001004", "0901ffd680138b0a", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170001004", "0901ffd680138b0b", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/editResponsibleStatement_3.xml"),
                                usuario: "WFORM" })

        organization = Organization.last

        expect(organization.represented_entities.count).to eq 3
        re_1 =  RepresentedEntity.where(identifier: "1").first
        expect(re_1.name).to eq "ENDESA"
        expect(re_1.to).to eq nil
        re_2 =  RepresentedEntity.where(identifier: "2").first
        expect(re_2.name).to eq "REPSOL"
        expect(re_2.to).not_to eq nil
        re_3 =  RepresentedEntity.where(identifier: "3").first
        expect(re_3.name).to eq "IBERDROLA"
        expect(re_3.to).to eq nil

        expect(organization.attachments.count).to eq 2
      end

    end

    describe "Remove responsible_statement" do

      it "Should remove 1 organization, soft_delete user and send email.", :wsdl do
        ActionMailer::Base.deliveries = []
        client = Savon::Client.new(
                  wsdl: application_base + api_responsible_statements_wsdl_path)

        set_attachment_stub("20170000996", "0901ffd680138ac3", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac4", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000996", "0901ffd680138ac5", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/newResponsibleStatement_3.xml"),
                                usuario: "WFORM" })

        organization = Organization.last
        expect(ActionMailer::Base.deliveries.count).to eq(1) #UserMailer.welcome(organization.user).deliver_now
        expect(organization.canceled_at).to eq nil
        expect(organization.user.deleted_at).to eq nil

        set_attachment_stub("20170000999", "0901ffd680138af3", "newResponsibleStatement_xml_attachment.xml")
        set_attachment_stub("20170000999", "0901ffd680138af4", "newResponsibleStatement_pdf_attachment_1.xml")
        set_attachment_stub("20170000999", "0901ffd680138af5", "newResponsibleStatement_pdf_attachment_2.xml")

        response = client.call(:inicio_expediente,
                               message: {
                                codTipoExpdiente: "1234",
                                xmlDatosEntrada: File.read("spec/fixtures/responsible_statement/removeResponsibleStatement_1.xml"),
                                usuario: "WFORM" })

        organization = Organization.last
        expect(ActionMailer::Base.deliveries.count).to eq(2) #OrganizationMailer.delete(@organization).deliver_now
        expect(organization.canceled_at).not_to eq nil
        expect(organization.user.deleted_at).not_to eq nil
      end
    end
  end

  def set_attachment_stub(num_anotacion, codigo_documento, file_name)
    message = { Aplicacion: "RLOBBIES", CodigoDocumento: codigo_documento, Sentido: "E", NumAnotacion: num_anotacion }
    RegistryApi.any_instance.stub(:get_documento_anotacion).with(message).and_return(File.read("spec/fixtures/responsible_statement/#{file_name}"))
  end

end
