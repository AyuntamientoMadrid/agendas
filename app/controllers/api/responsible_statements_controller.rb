require 'nokogiri'
require 'stringio'

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

      organization_params = {}

      organization_params = add_attributes(doc, organization_params)

      organization = Organization.where(identifier: organization_params[:identifier]).first

      action = ""
      if doc.xpath("//formulario/nombre=876")
        organization = Organization.create(organization_params)
        action = "create"
      elsif organization.present? && doc.xpath("//formulario/nombre=877")
        organization_params[:user_attributes] = check_user_attributes(organization, organization_params[:user_attributes])
        action = organization.user.email != organization_params[:user_attributes][:email] ? "update-with-welcome-email" : "update"
        organization.update_attributes(organization_params)
      elsif organization.present? && doc.xpath("//formulario/nombre=878")
        action = "destroy"
        organization.update(canceled_at: Time.zone.now)
      else
        organization = Organization.new
        action = "unknow-action"
      end

      take_actions(action, organization) if organization.valid?

      render soap: {
        codRetorno: organization.valid? ? "" : "0",
        descError: organization.valid? ? "OK" : organization.errors.full_messages.join(', '),
        idExpediente: "idExpediente",
        refExpediente: "refExpediente",
      }

    end

    private

    def take_actions(action, organization)
      case action
      when 'create'
        UserMailer.welcome(organization.user).deliver_now
      when 'update'
        OrganizationMailer.update(organization).deliver_now
        organization.update(modification_date: Date.current)
      when 'update-with-welcome-email'
        UserMailer.welcome(organization.user).deliver_now
        OrganizationMailer.update(organization).deliver_now
        organization.update(modification_date: Date.current)
      when 'destroy'
        organization.user.soft_delete
        OrganizationMailer.delete(organization).deliver_now
      when 'unknow-action'
      end
    end

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

    def add_attributes(doc, organization_params)
      # 0. Numero Anotación
      organization_params = add_reference(doc, organization_params)
      # 1. Datos identificativos de quien aparecera como inscrito en el registro
      organization_params = add_lobby_data(doc, organization_params)
      # 2. Datos de la persona o entidad representante
      organization_params = add_legal_representant(doc, organization_params)
      # 3. Persona física de contacto
      organization_params = add_user(doc, organization_params)
      # 4. Datos de quien va a ejercer la actividad de lobby por cuenta propia
      organization_params = add_own_lobby_activity(doc, organization_params)
      # 5. Datos personas o entidades sin personalidad a quienes se va a representar
      organization_params = add_foreign_lobby_activity(doc, organization_params)
      # 6. Attachments
      organization_params = add_attachments(doc, organization_params)

      organization_params
    end

    def add_reference(doc, organization_params)
      reference = doc.xpath("//numAnotacion").text
      organization_params =  organization_params.merge(reference: reference)
    end

    def add_lobby_data(doc, organization_params)
      identifier     = key_content(doc, "COMUNES_INTERESADO_NUMIDENT")
      name           = get_name(doc, "COMUNES_INTERESADO_NOMBRE", "COMUNES_INTERESADO_RAZONSOCIAL")
      first_surname  = key_content(doc, "COMUNES_INTERESADO_APELLIDO1")
      second_surname = key_content(doc, "COMUNES_INTERESADO_APELLIDO2")
      country        = key_content(doc, "COMUNES_INTERESADO_PAIS")
      province       = key_content(doc, "COMUNES_INTERESADO_PROVINCIA")
      town           = key_content(doc, "COMUNES_INTERESADO_MUNICIPIO")
      address_type   = key_content(doc, "COMUNES_INTERESADO_TIPOVIA")
      address        = key_content(doc, "COMUNES_INTERESADO_NOMBREVIA")
      number_type    = get_number_type(doc)
      number         = key_content(doc, "COMUNES_INTERESADO_NUMERO")
      gateway        = key_content(doc, "COMUNES_INTERESADO_PORTAL")
      stairs         = key_content(doc, "COMUNES_INTERESADO_ESCALERA")
      floor          = key_content(doc, "COMUNES_INTERESADO_PLANTA")
      door           = key_content(doc, "COMUNES_INTERESADO_PUERTA")
      postal_code    = key_content(doc, "COMUNES_INTERESADO_CODPOSTAL")
      email          = key_content(doc, "COMUNES_INTERESADO_EMAIL")
      phones         = get_phones(doc, "COMUNES_INTERESADO_MOVIL", "COMUNES_INTERESADO_TELEFONO")
      category       = get_category(doc)
      description    = key_content(doc, "COMUNES_INTERESADO_FINALIDAD")
      web            = key_content(doc, "COMUNES_INTERESADO_WEB")
      registered_lobby_ids = get_registered_lobby_ids(doc)
      check_email    = get_check(doc, "COMUNES_INTERESADO_CHECKEMAIL")
      check_sms      = get_check(doc, "COMUNES_INTERESADO_CHECKSMS")
      organization_params =  organization_params.merge(identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname,
                                                       country: country, province: province, town: town, address_type: address_type, address: address,
                                                       number_type: number_type, number: number, gateway: gateway, stairs: stairs, floor: floor, door: door, postal_code: postal_code,
                                                       email: email, phones: phones, category: category, description: description, web: web, registered_lobby_ids: registered_lobby_ids,
                                                       check_email: check_email, check_sms: check_sms, entity_type: :lobby)
    end

    def add_legal_representant(doc, organization_params)
      legal_representant_identifier     = key_content(doc, "COMUNES_REPRESENTANTE_NUMIDENT")

      if legal_representant_identifier.present?
        legal_representant_name           = get_name(doc, "COMUNES_REPRESENTANTE_NOMBRE", "COMUNES_REPRESENTANTE_RAZONSOCIAL")
        legal_representant_first_surname  = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO1")
        legal_representant_second_surname = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO2")
        legal_representant_email          = key_content(doc, "COMUNES_REPRESENTANTE_EMAIL")
        legal_representant_phones         = get_phones(doc, "COMUNES_REPRESENTANTE_MOVIL", "COMUNES_REPRESENTANTE_TELEFONO")
        legal_representant_check_email    = get_check(doc, "COMUNES_REPRESENTANTE_CHECKEMAIL")
        legal_representant_check_sms      = get_check(doc, "COMUNES_REPRESENTANTE_CHECKSMS")
        legal_representant_attributes = { identifier: legal_representant_identifier, name: legal_representant_name, first_surname: legal_representant_first_surname,
                                          second_surname: legal_representant_second_surname, email: legal_representant_email, phones: legal_representant_phones,
                                          check_email: legal_representant_check_email, check_sms: legal_representant_check_sms }

        organization_params = organization_params.merge(legal_representant_attributes: legal_representant_attributes)
      end
      organization_params
    end

    def add_user(doc, organization_params)
      user_identifier      = key_content(doc, "COMUNES_NOTIFICACION_NUMIDENT")
      user_first_name      = key_content(doc, "COMUNES_NOTIFICACION_NOMBRE")
      user_last_name       = get_user_last_name(doc)
      user_role            = :lobby
      user_email           = key_content(doc, "COMUNES_NOTIFICACION_EMAIL")
      user_active          = 1
      user_phones          = get_phones(doc, "COMUNES_NOTIFICACION_MOVIL", "COMUNES_NOTIFICACION_TELEFONO")
      user_password        = get_random_password
      user_attributes = { identifier: user_identifier, first_name: user_first_name, last_name: user_last_name, role: user_role, email: user_email, active: user_active, phones: user_phones, password: user_password, password_confirmation: user_password }

      organization_params = organization_params.merge(user_attributes: user_attributes)
    end

    def add_own_lobby_activity(doc, organization_params)
      own_lobby_activity = get_boolean_field_value(doc, "ACTIVIDAD_PROPIA")
      fiscal_year        = key_content(doc, "EJERCICIO_ANUAL")
      range_fund         = get_range_fund(doc, "FONDOS1")
      contract           = get_boolean_field_value(doc, "RECIBI_AYUDAS")
      subvention         = get_boolean_field_value(doc, "CELEBRA_CON")

      organization_params =  organization_params.merge(own_lobby_activity: own_lobby_activity, fiscal_year: fiscal_year, range_fund: range_fund, contract: contract, subvention: subvention)
    end

    def add_foreign_lobby_activity(doc, organization_params)
      foreign_lobby_activity = get_boolean_field_value(doc, "ACTIVIDAD_AJENA")
      represented_entities_attributes = {}
      #RepresentedEntity 1
      represented_entities_attributes = add_represented_entity(doc, represented_entities_attributes, "DNI_REPRESENTA", "NOMBRE_REPRESENTA", "APELLIDO1_REPRESENTA", "APELLIDO2_REPRESENTA", "FECHA_REPRESENTA", "EJERCICIO_REPRESENTA", "FONDOS_REPRESENTA", "ENTIDAD_AYUDA_REPRESENTA", "ENTIDAD_CON_REPRESENTA", "MODPERSONA1", "1")
      #RepresentedEntity 2
      represented_entities_attributes = add_represented_entity(doc, represented_entities_attributes, "DNI_REPRESENTA2", "NOMBRE_REPRESENTA2", "APELLIDO1_REPRESENTA2", "APELLIDO2_REPRESENTA2", "FECHA_REPRESENTA2", "EJERCICIO_REPRESENTA2", "FONDOS_REPRESENTA2", "ENTIDAD_AYUDA_REPRESENTA2", "ENTIDAD_CON_REPRESENTA2", "MODPERSONA2", "2")
      #RepresentedEntity 3
      represented_entities_attributes = add_represented_entity(doc, represented_entities_attributes, "DNI_REPRESENTA3", "NOMBRE_REPRESENTA3", "APELLIDO1_REPRESENTA3", "APELLIDO2_REPRESENTA3", "FECHA_REPRESENTA3", "EJERCICIO_REPRESENTA3", "FONDOS_REPRESENTA3", "ENTIDAD_AYUDA_REPRESENTA3", "ENTIDAD_CON_REPRESENTA3", "MODPERSONA3", "3")
      #RepresentedEntity 4
      represented_entities_attributes = add_represented_entity(doc, represented_entities_attributes, "DNI_REPRESENTA4", "NOMBRE_REPRESENTA4", "APELLIDO1_REPRESENTA4", "APELLIDO2_REPRESENTA4", "FECHA_REPRESENTA4", "EJERCICIO_REPRESENTA4", "FONDOS_REPRESENTA4", "ENTIDAD_AYUDA_REPRESENTA4", "ENTIDAD_CON_REPRESENTA4", "MODPERSONA4", "4")

      organization_params =  organization_params.merge(foreign_lobby_activity: foreign_lobby_activity)

      organization_params =  represented_entities_attributes.present? ? organization_params.merge(represented_entities_attributes: represented_entities_attributes) : organization_params

      return organization_params
    end

    def add_represented_entity(doc, represented_entities_attributes, identifier, name, first_surname, last_surname, from, fiscal_year, range_fund, subvention, contract, modification_type, hash_id)
      identifier     = key_content(doc, identifier)
      if identifier.present?

        name           = key_content(doc, name)
        first_surname  = key_content(doc, first_surname)
        second_surname = key_content(doc, last_surname)
        from           = key_content(doc, from)
        fiscal_year    = key_content(doc, fiscal_year)
        range_fund     = get_range_fund(doc, range_fund)
        subvention     = get_boolean_field_value(doc, subvention)
        contract       = get_boolean_field_value(doc, contract)
        to             = get_destroy(doc, modification_type)

        represented_entity_params = { identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname, from: from, to: to, fiscal_year: fiscal_year, range_fund: range_fund, subvention: subvention, contract: contract, _destroy: "false" }
        organization = Organization.where(identifier: key_content(doc, "COMUNES_INTERESADO_NUMIDENT")).first
        re = organization.represented_entities.where(identifier: identifier).first if organization.present?
        if organization.present? && re.present?
          if to.blank?
            represented_entity_params = represented_entity_params.merge(id: re.id)
          else
            represented_entity_params = { identifier: re.identifier, name: re.name, first_surname: re.first_surname, second_surname: re.second_surname, from: re.from, to: to, fiscal_year: re.fiscal_year, range_fund: re.range_fund, subvention: re.subvention, contract: re.contract, _destroy: "false", id: re.id }
          end
        end
        represented_entities_attributes = represented_entities_attributes.merge(hash_id => represented_entity_params)
      end
      represented_entities_attributes = represented_entities_attributes.merge(represented_entities_attributes)
    end

    def add_attachments(doc, organization_params)
      reference = doc.xpath("//numAnotacion").text
      sentido = doc.xpath("//sentido").text
      registry_api = RegistryApi.new
      attachments_attributes = {}
      doc.xpath("//Documento").each_with_index do |document, index|
        document_name = document.xpath('descripcion').text.include?(".") ? document.xpath('descripcion').text : "#{document.xpath('descripcion').text}.#{document.xpath('tipoDocumento').text.downcase}"
        unless document_name == "XMLIntercambioRegistro.xml" || document_name == "Documento firmado por el ciudadano.pdf"
          message =  { Aplicacion: "RLOBBIES", CodigoDocumento: "#{document.xpath('codigo').text}", Sentido: sentido, NumAnotacion: reference }
          content_attachment_xml = Nokogiri.XML(registry_api.get_documento_anotacion(message))

          File.open(Rails.root.join('tmp', document_name), 'wb') do |f|
            f.puts(content_attachment_xml.xpath("//documento").text.unpack("m"))
          end
          attributes = { file: File.open(Rails.root.join('tmp', document_name)) }
          attachments_attributes = attachments_attributes.merge(index => attributes)
        end
      end
      organization_params = organization_params.merge(attachments_attributes: attachments_attributes)
    end

    def key_content(doc, key)
      variable = doc.at("//variable/*[text()= '#{key}']")
      variable.present? && variable.next_element.text.present? ? variable.next_element.text : nil
    end

    def get_name(doc, name, social_reason)
      if key_content(doc, name).present?
        name = key_content(doc, name)
      elsif key_content(doc, social_reason).present?
        name = key_content(doc, social_reason)
      else
        name = nil
      end
      return name
    end

    def get_user_last_name(doc)
      last_name = nil
      if key_content(doc, "COMUNES_NOTIFICACION_APELLIDO1").present?
        last_name = key_content(doc, "COMUNES_NOTIFICACION_APELLIDO1")
      end
      if key_content(doc, "COMUNES_NOTIFICACION_APELLIDO2").present?
        last_name += " #{key_content(doc, "COMUNES_NOTIFICACION_APELLIDO2")}"
      end
      return last_name
    end

    def get_phones(doc, mobile, phone)
      phones = nil
      if key_content(doc, mobile).present?
        phones = key_content(doc, mobile)
      end
      if key_content(doc, phone).present?
        if phones.present?
          phones += ", " + key_content(doc, phone)
        else
          phones = key_content(doc, phone)
        end
      end
      return phones
    end

    def get_category(doc)
      if key_content(doc, "COMUNES_INTERESADO_CATEG").present?
        case key_content(doc, "COMUNES_INTERESADO_CATEG")
        when 'PRO'
          Category.where(name: "Consultoría profesional y despachos de abogados").first
        when 'EMP'
          Category.where(name: "Empresas").first
        when 'ASO'
          Category.where(name: "Asociaciones").first
        when 'FUN'
          Category.where(name: "Fundaciones").first
        when 'SIN'
          Category.where(name: "Sindicatos y organizaciones profesionales").first
        when 'ORG'
          Category.where(name: "Organizaciones empresariales").first
        when 'ONG'
          Category.where(name: "ONGs y plataformas sin personalidad jurídica").first
        when 'UNI'
          Category.where(name: "Universidades y centros de investigación").first
        when 'COR'
          Category.where(name: "Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)").first
        when 'IGL'
          Category.where(name: "Iglesia y otras confesiones").first
        else
          Category.where(name: "Otro tipo de sujetos").first
        end
      end
    end

    def get_registered_lobby_ids(doc)
      registered_lobby_ids = [RegisteredLobby.where(name: "Ninguno").first.id]
      if key_content(doc, "COMUNES_INTERESADO_INSCRIPCION") == "S"
        ids = []
        ids << RegisteredLobby.where(name: "Generalidad catalunya").first.id if key_content(doc, "COMUNES_INTERESADO_GENERAL") == "true"
        ids << RegisteredLobby.where(name: "CNMC").first.id                  if key_content(doc, "COMUNES_INTERESADO_CNMC") == "true"
        ids << RegisteredLobby.where(name: "Unión Europea").first.id         if key_content(doc, "COMUNES_INTERESADO_UE") == "true"
        ids << RegisteredLobby.where(name: "Otro").first.id                  if key_content(doc, "COMUNES_INTERESADO_OTROS") == "true"
        registered_lobby_ids = ids
      end
      return registered_lobby_ids
    end

    def get_range_fund(doc, field)
      range_fund = nil
      if key_content(doc, field).present?
        case key_content(doc, field)
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
      Devise.friendly_token.first(8)
    end

    def get_boolean_field_value(doc, field)
      key_content(doc, field) == "S"
    end

    def get_check(doc, field)
      key_content(doc, field) == "true"
    end

    def check_user_attributes(organization, user_attributes)
      if user_attributes[:email].present? && (organization.user.email == user_attributes[:email])
        user_attributes.delete("password")
        user_attributes.delete("password_confirmation")
        user_attributes[:id] = organization.user.id
      end
      return user_attributes
    end

    def get_number_type(doc)
      number_type = nil
      if key_content(doc, "COMUNES_INTERESADO_TIPONUM").present?
        case key_content(doc, "COMUNES_INTERESADO_TIPONUM")
        when 'NUM'
          number_type = "Número"
        when 'KM'
          number_type = "Kilómetro"
        when 'S/N'
          number_type = "S/N"
        end
      end
      return number_type
    end

    def get_destroy(doc, field)
      (key_content(doc, field) == "baja") ? Time.zone.now : nil
    end

  end
end
