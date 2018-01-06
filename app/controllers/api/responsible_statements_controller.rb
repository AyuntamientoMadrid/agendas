require 'nokogiri'

module Api
  class ResponsibleStatementsController < ApplicationController
    soap_service namespace: "urn:api/responsible_statements/wsdl",
                 wsdl_style: :rpc

    before_filter :parse_request, only: :inicioExpediente
    soap_action "inicioExpediente",
                args: {
                  codTipoExpdiente: :string,
                  xmlDatosEntrada: :string,
                  listDocs: [ idDocumento: :string ],
                  listFormatos: [ idTipoDocumento: :string ],
                  usuario: :string
                },
                return: {
                  codRetorno: :string,
                  descError: :string,
                  idExpediente: :integer,
                  refExpediente: :string
                }
    def inicioExpediente
      doc = Nokogiri.XML(params[:xmlDatosEntrada])

      # 0. Numero Anotación
      reference = doc.xpath("//numAnotacion")

      # responsible_statement.xpath("//formulario").each do |form|
      #   if form.xpath("nombre=876")
      # 1. datos identificativos de quien aparecera como inscrito en el registro
      identifier     = key_content(doc, "COMUNES_INTERESADO_NUMIDENT") ? key_content(doc, "COMUNES_INTERESADO_NUMIDENT").next_element.text : nil
      name           = get_organization_name(doc)
      first_surname  = key_content(doc, "COMUNES_INTERESADO_APELLIDO1") ? key_content(doc, "COMUNES_INTERESADO_APELLIDO1").next_element.text : nil
      second_surname = key_content(doc, "COMUNES_INTERESADO_APELLIDO2") ? key_content(doc, "COMUNES_INTERESADO_APELLIDO2").next_element.text : nil
      country        = key_content(doc, "COMUNES_INTERESADO_PAIS")      ? key_content(doc, "COMUNES_INTERESADO_PAIS").next_element.text : nil
      province       = key_content(doc, "COMUNES_INTERESADO_PROVINCIA") ? key_content(doc, "COMUNES_INTERESADO_PROVINCIA").next_element.text : nil
      town           = key_content(doc, "COMUNES_INTERESADO_MUNICIPIO") ? key_content(doc, "COMUNES_INTERESADO_MUNICIPIO").next_element.text : nil
      address_type   = key_content(doc, "COMUNES_INTERESADO_TIPOVIA")   ? key_content(doc, "COMUNES_INTERESADO_TIPOVIA").next_element.text : nil
      address        = key_content(doc, "COMUNES_INTERESADO_NOMBREVIA") ? key_content(doc, "COMUNES_INTERESADO_NOMBREVIA").next_element.text : nil
      # num_type       = key_content(doc, "COMUNES_INTERESADO_TIPONUM") ? key_content(doc, "COMUNES_INTERESADO_TIPONUM").next_element.text : nil
      number         = key_content(doc, "COMUNES_INTERESADO_NUMERO")    ? key_content(doc, "COMUNES_INTERESADO_NUMERO").next_element.text : nil
      gateway        = key_content(doc, "COMUNES_INTERESADO_PORTAL")    ? key_content(doc, "COMUNES_INTERESADO_PORTAL").next_element.text : nil
      stairs         = key_content(doc, "COMUNES_INTERESADO_ESCALERA")  ? key_content(doc, "COMUNES_INTERESADO_ESCALERA").next_element.text : nil
      floor          = key_content(doc, "COMUNES_INTERESADO_PLANTA")    ? key_content(doc, "COMUNES_INTERESADO_PLANTA").next_element.text : nil
      door           = key_content(doc, "COMUNES_INTERESADO_PUERTA")    ? key_content(doc, "COMUNES_INTERESADO_PUERTA").next_element.text : nil
      postal_code    = key_content(doc, "COMUNES_INTERESADO_CODPOSTAL") ? key_content(doc, "COMUNES_INTERESADO_CODPOSTAL").next_element.text : nil
      email          = key_content(doc, "COMUNES_INTERESADO_EMAIL")     ? key_content(doc, "COMUNES_INTERESADO_EMAIL").next_element.text : nil
      phones         = get_organization_phones(doc)
      category       = get_category(doc)
      description    = key_content(doc, "COMUNES_INTERESADO_FINALIDAD") ? key_content(doc, "COMUNES_INTERESADO_FINALIDAD").next_element.text : nil
      web            = key_content(doc, "COMUNES_INTERESADO_WEB")       ? key_content(doc, "COMUNES_INTERESADO_WEB").next_element.text : nil
      registered_lobby_ids = get_registered_lobby_ids(doc)

      # 2. Datos de la persona o entidad representante
      legal_representant_identifier     = key_content(doc, "COMUNES_REPRESENTANTE_NUMIDENT")  ? key_content(doc, "COMUNES_REPRESENTANTE_NUMIDENT").next_element.text : nil
      legal_representant_name           = get_legal_representant_name(doc)
      legal_representant_first_surname  = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO1") ? key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO1").next_element.text : nil
      legal_representant_second_surname = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO2") ? key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO2").next_element.text : nil
      legal_representant_email          = key_content(doc, "COMUNES_REPRESENTANTE_EMAIL")     ? key_content(doc, "COMUNES_REPRESENTANTE_EMAIL").next_element.text : nil
      legal_representant_phones         = get_legal_representant_phones(doc)
      legal_representant_attributes = { identifier: legal_representant_identifier, name: legal_representant_name, first_surname: legal_representant_first_surname, second_surname: legal_representant_second_surname, email: legal_representant_email, phones: legal_representant_phones }

      # 3. Persona física de contacto
      # user_identifier      = key_content(doc, "COMUNES_NOTIFICACION_NUMIDENT") ? key_content(doc, "COMUNES_NOTIFICACION_NUMIDENT").next_element.text : nil
      user_first_name      = key_content(doc, "COMUNES_NOTIFICACION_NOMBRE")   ? key_content(doc, "COMUNES_NOTIFICACION_NOMBRE").next_element.text : nil
      user_last_name       = get_user_last_name(doc)
      user_role            = :lobby
      user_email           = key_content(doc, "COMUNES_NOTIFICACION_EMAIL")    ? key_content(doc, "COMUNES_NOTIFICACION_EMAIL").next_element.text : nil
      user_active          = 1
      user_phones          = get_user_phones(doc)
      user_password        = get_random_password
      user_attributes = { first_name: user_first_name, last_name: user_last_name, role: user_role, email: user_email, active: user_active, phones: user_phones, password: user_password, password_confirmation: user_password }

      # 4. Datos de quien va a ejercer la actividad de lobby por cuenta propia
      fiscal_year     = key_content(doc, "EJERCICIO_ANUAL") ? key_content(doc, "EJERCICIO_ANUAL").next_element.text : nil
      range_fund      = get_organization_range_fund(doc)
      contract        = get_organization_contract(doc)
      subvention      = get_organization_subvention(doc)

      # 5. Datos personas o entidades sin personalidad a quienes se va a representar
      # represented_entities_attributes: [:id, :identifier, :name, :first_surname, :second_surname, :from, :fiscal_year, :range_fund, :subvention, :contract, :_destroy]
      # represented_entities_attributes = [identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname, from: from, fiscal_year: fiscal_year, range_fund: range_fund, subvention: subvention, contract: contract]

      # certain_term
      # code_of_conduct_term
      # created_at
      # updated_at
      # inscription_reference
      # inscription_date
      # entity_type
      # neighbourhood
      # district
      # scope
      # associations_count
      # members_count
      # approach
      # invalidated_at
      # canceled_at
      # invalidated_reasons
      # modification_date
      # gift_term
      # lobby_term
      # legal_representant_attributes: [x:identifier, x:name, x:first_surname, x:second_surname, x:phones, x:email, :_destroy]
      # user_attributes: [:id, :first_name, :last_name, :role, :email, :active, :phones, :password, :password_confirmation]
      o = Organization.create(identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname, country: country, province: province, town: town, address_type: address_type, address: address, number: number, gateway: gateway, stairs: stairs, floor: floor, door: door, postal_code: postal_code, email: email, phones: phones, category: category, description: description,
                          registered_lobby_ids: registered_lobby_ids, web: web, fiscal_year: fiscal_year, range_fund: range_fund, contract: contract, subvention: subvention,
                           user_attributes: user_attributes)
debugger
      # legal_representant_attributes: legal_representant_attributes,
      #TODO:  build organization from received responsible statement: statement, save and respond
      puts doc

      render soap: {
        codRetorno: "",
        descError: "OK",
        idExpediente: "idExpediente",
        refExpediente: "refExpediente",
      }
    end

    private

    def parse_request
      if params[:codTipoExpdiente].blank?
        render_error "codTipoExpdiente cannot be blank"
      elsif params[:xmlDatosEntrada].blank?
        render_error "xmlDatosEntrada cannot be blank"
      elsif params[:usuario].blank?
        render_error "usuario cannot be blank"
      end
    end

    def render_error(descError)
      render soap: {
        codRetorno: 0,
        descError: descError,
      }
    end

    def key_content(doc, key)
      doc.at("//variable/*[text() = '#{key}']")
    end

    def get_organization_name(doc)
      name = nil
      if key_content(doc, "COMUNES_INTERESADO_NOMBRE") || key_content(doc, "COMUNES_INTERESADO_RAZONSOCIAL")
        if key_content(doc, "COMUNES_INTERESADO_NOMBRE")
          name = key_content(doc, "COMUNES_INTERESADO_NOMBRE").next_element.text
        else
          name = key_content(doc, "COMUNES_INTERESADO_RAZONSOCIAL").next_element.text
        end
      end
      return name
    end

    def get_legal_representant_name(doc)
      name = nil
      if key_content(doc, "COMUNES_REPRESENTANTE_NOMBRE") || key_content(doc, "COMUNES_REPRESENTANTE_RAZONSOCIAL")
        if key_content(doc, "COMUNES_REPRESENTANTE_NOMBRE")
          name = key_content(doc, "COMUNES_REPRESENTANTE_NOMBRE").next_element.text
        else
          name = key_content(doc, "COMUNES_REPRESENTANTE_RAZONSOCIAL").next_element.text
        end
      end
      return name
    end

    def get_user_last_name(doc)
      last_name = nil
      if key_content(doc, "COMUNES_NOTIFICACION_APELLIDO1")
        last_name = key_content(doc, "COMUNES_NOTIFICACION_APELLIDO1").next_element.text
      end
      if key_content(doc, "COMUNES_NOTIFICACION_APELLIDO2")
        last_name += key_content(doc, "COMUNES_NOTIFICACION_APELLIDO2").next_element.text
      end
      return last_name
    end

    def get_organization_phones(doc)
      phones = nil
      if key_content(doc, "COMUNES_INTERESADO_MOVIL")
        phones = key_content(doc, "COMUNES_INTERESADO_MOVIL").next_element.text
      end
      if key_content(doc, "COMUNES_INTERESADO_TELEFONO")
        if phones.present?
          phones += ", " + key_content(doc, "COMUNES_INTERESADO_TELEFONO").next_element.text
        else
          phones = key_content(doc, "COMUNES_INTERESADO_TELEFONO").next_element.text
        end
      end
      return phones
    end

    def get_legal_representant_phones(doc)
      phones = nil
      if key_content(doc, "COMUNES_REPRESENTANTE_MOVIL")
        phones = key_content(doc, "COMUNES_REPRESENTANTE_MOVIL").next_element.text
      end
      if key_content(doc, "COMUNES_REPRESENTANTE_TELEFONO")
        if phones.present?
          phones += ", " + key_content(doc, "COMUNES_REPRESENTANTE_TELEFONO").next_element.text
        else
          phones = key_content(doc, "COMUNES_REPRESENTANTE_TELEFONO").next_element.text
        end
      end
      return phones
    end

    def get_user_phones(doc)
      phones = nil
      if key_content(doc, "COMUNES_NOTIFICATION_MOVIL")
        phones = key_content(doc, "COMUNES_NOTIFICATION_MOVIL").next_element.text
      end
      if key_content(doc, "COMUNES_NOTIFICATION_TELEFONO")
        if phones.present?
          phones += ", " + key_content(doc, "COMUNES_NOTIFICATION_TELEFONO").next_element.text
        else
          phones = key_content(doc, "COMUNES_NOTIFICATION_TELEFONO").next_element.text
        end
      end
      return phones
    end

    def get_category(doc)
      category = nil
      if key_content(doc, "COMUNES_INTERESADO_CATEG")
        case key_content(doc, "COMUNES_INTERESADO_CATEG").next_element.text
        when 'PRO'
          category = Category.where(name: "Consultoría profesional y despachos de abogados").first
        when 'EMP'
          category = Category.where(name: "Empresas").first
        when 'ASO'
          category = Category.where(name: "Asociaciones").first
        when 'FUN'
          category = Category.where(name: "Fundaciones").first
        when 'SIN'
          category = Category.where(name: "Sindicatos y organizaciones profesionales").first
        when 'ORG'
          category = Category.where(name: "Organizaciones empresariales").first
        when 'ONG'
          category = Category.where(name: "ONGs y plataformas sin personalidad jurídica").first
        when 'UNI'
          category = Category.where(name: "Universidades y centros de investigación").first
        when 'COR'
          category = Category.where(name: "Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)").first
        when 'IGL'
          category = Category.where(name: "Iglesia y otras confesiones").first
        else
          category = Category.where(name: "Otro tipo de sujetos").first
        end
      end
      return category
    end

    def get_registered_lobby_ids(doc)
      registered_lobby_ids = [RegisteredLobby.where(name: "no_record").first.id]
      if key_content(doc, "COMUNES_INTERESADO_INSCRIPCION").next_element.text == "S"
        ids = []
        ids << RegisteredLobby.where(name: "generalitat_catalunya").first.id if key_content(doc, "COMUNES_INTERESADO_GENERAL").next_element.text == true
        ids << RegisteredLobby.where(name: "cnmc").first.id                  if key_content(doc, "COMUNES_INTERESADO_CNMC").next_element.text == true
        ids << RegisteredLobby.where(name: "europe_union").first.id          if key_content(doc, "COMUNES_INTERESADO_UE").next_element.text == true
        ids << RegisteredLobby.where(name: "others").first.id                if key_content(doc, "COMUNES_INTERESADO_OTROS").next_element.text == true
        registered_lobby_ids = ids
      end
      return registered_lobby_ids
    end

    def get_organization_range_fund(doc)
      range_fund = nil
      if key_content(doc, "FONDOS1")
        case key_content(doc, "FONDOS1").next_element.text
        when "1"
          range_fund = :range_1
        when "2"
          range_fund = :range_2
        when "3"
          range_fund = :range_3
        when "4"
          range_fund = :range_4
        end
      end
      return range_fund
    end

    def get_random_password
      (0...8).map { (65 + rand(26)).chr }.join
    end

    def get_organization_contract(doc)
      contract = false
      if key_content(doc, "RECIBI_AYUDAS")
         contract = key_content(doc, "RECIBI_AYUDAS").next_element.text == "S"
      end
      return contract
    end

    def get_organization_subvention(doc)
      subvention = false
      if key_content(doc, "CELEBRA_CON")
         subvention = key_content(doc, "CELEBRA_CON").next_element.text == "S"
      end
      return subvention
    end
  end
end
