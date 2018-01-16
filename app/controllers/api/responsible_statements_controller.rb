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
      reference = doc.xpath("//numAnotacion").text

      # 1. datos identificativos de quien aparecera como inscrito en el registro
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

      # 2. Datos de la persona o entidad representante
      legal_representant_identifier     = key_content(doc, "COMUNES_REPRESENTANTE_NUMIDENT")
      legal_representant_name           = get_name(doc, "COMUNES_REPRESENTANTE_NOMBRE", "COMUNES_REPRESENTANTE_RAZONSOCIAL")
      legal_representant_first_surname  = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO1")
      legal_representant_second_surname = key_content(doc, "COMUNES_REPRESENTANTE_APELLIDO2")
      legal_representant_email          = key_content(doc, "COMUNES_REPRESENTANTE_EMAIL")
      legal_representant_phones         = get_phones(doc, "COMUNES_REPRESENTANTE_MOVIL", "COMUNES_REPRESENTANTE_TELEFONO")
      legal_representant_check_email    = get_check(doc, "COMUNES_REPRESENTANTE_CHECKEMAIL")
      legal_representant_check_sms      = get_check(doc, "COMUNES_REPRESENTANTE_CHECKSMS")
      legal_representant_attributes = { identifier: legal_representant_identifier, name: legal_representant_name, first_surname: legal_representant_first_surname, second_surname: legal_representant_second_surname, email: legal_representant_email, phones: legal_representant_phones, check_email: legal_representant_check_email, check_sms: legal_representant_check_sms }

      # 3. Persona física de contacto
      user_identifier      = key_content(doc, "COMUNES_NOTIFICACION_NUMIDENT")
      user_first_name      = key_content(doc, "COMUNES_NOTIFICACION_NOMBRE")
      user_last_name       = get_user_last_name(doc)
      user_role            = :lobby
      user_email           = key_content(doc, "COMUNES_NOTIFICACION_EMAIL")
      user_active          = 1
      user_phones          = get_phones(doc, "COMUNES_NOTIFICACION_MOVIL", "COMUNES_NOTIFICACION_TELEFONO")
      user_password        = get_random_password
      user_attributes = { identifier: user_identifier, first_name: user_first_name, last_name: user_last_name, role: user_role, email: user_email, active: user_active, phones: user_phones, password: user_password, password_confirmation: user_password }

      # 4. Datos de quien va a ejercer la actividad de lobby por cuenta propia
      fiscal_year     = key_content(doc, "EJERCICIO_ANUAL")
      range_fund      = get_range_fund(doc, "FONDOS1")
      contract        = get_boolean_field_value(doc, "RECIBI_AYUDAS")
      subvention      = get_boolean_field_value(doc, "CELEBRA_CON")

      # 5. Datos personas o entidades sin personalidad a quienes se va a representar
      #RepresentedEntity 1 (re_1)
      re_1_identifier     = key_content(doc, "DNI_REPRESENTA")
      re_1_name           = key_content(doc, "NOMBRE_REPRESENTA")
      re_1_first_surname  = key_content(doc, "APELLIDO1_REPRESENTA")
      re_1_second_surname = key_content(doc, "APELLIDO2_REPRESENTA")
      re_1_from           = key_content(doc, "FECHA_REPRESENTA")
      re_1_fiscal_year    = key_content(doc, "EJERCICIO_REPRESENTA")
      re_1_range_fund     = get_range_fund(doc, "FONDOS_REPRESENTA")
      re_1_subvention     = get_boolean_field_value(doc, "ENTIDAD_AYUDA_REPRESENTA")
      re_1_contract       = get_boolean_field_value(doc, "ENTIDAD_CON_REPRESENTA")
      re_1_destroy        = get_destroy(doc, "MODPERSONA")
      represented_entity_1 = { identifier: re_1_identifier, name: re_1_name, first_surname: re_1_first_surname, second_surname: re_1_second_surname, from: re_1_from, fiscal_year: re_1_fiscal_year, range_fund: re_1_range_fund, subvention: re_1_subvention, contract: re_1_contract, _destroy: re_1_destroy }
      represented_entities_attributes = { "1" => represented_entity_1 }

      #RepresentedEntity 2 (re_2)
      re_2_identifier     = key_content(doc, "DNI_REPRESENTA2")
      re_2_name           = key_content(doc, "NOMBRE_REPRESENTA2")
      re_2_first_surname  = key_content(doc, "APELLIDO1_REPRESENTA2")
      re_2_second_surname = key_content(doc, "APELLIDO2_REPRESENTA2")
      re_2_from           = key_content(doc, "FECHA_REPRESENTA2")
      re_2_fiscal_year    = key_content(doc, "EJERCICIO_REPRESENTA2")
      re_2_range_fund     = get_range_fund(doc, "FONDOS_REPRESENTA2")
      re_2_subvention     = get_boolean_field_value(doc, "ENTIDAD_AYUDA_REPRESENTA2")
      re_2_contract       = get_boolean_field_value(doc, "ENTIDAD_CON_REPRESENTA2")
      re_2_destroy        = get_destroy(doc, "MODPERSONA2")
      represented_entity_2 = { identifier: re_2_identifier, name: re_2_name, first_surname: re_2_first_surname, second_surname: re_2_second_surname, from: re_2_from, fiscal_year: re_2_fiscal_year, range_fund: re_2_range_fund, subvention: re_2_subvention, contract: re_2_contract, _destroy: re_2_destroy }
      represented_entities_attributes = { "1" => represented_entity_1, "2" => represented_entity_2 }

      #RepresentedEntity 3 (re_3)
      re_3_identifier     = key_content(doc, "DNI_REPRESENTA3")
      re_3_name           = key_content(doc, "NOMBRE_REPRESENTA3")
      re_3_first_surname  = key_content(doc, "APELLIDO1_REPRESENTA3")
      re_3_second_surname = key_content(doc, "APELLIDO3_REPRESENTA3")
      re_3_from           = key_content(doc, "FECHA_REPRESENTA3")
      re_3_fiscal_year    = key_content(doc, "EJERCICIO_REPRESENTA3")
      re_3_range_fund     = get_range_fund(doc, "FONDOS_REPRESENTA3")
      re_3_subvention     = get_boolean_field_value(doc, "ENTIDAD_AYUDA_REPRESENTA3")
      re_3_contract       = get_boolean_field_value(doc, "ENTIDAD_CON_REPRESENTA3")
      re_3_destroy        = get_destroy(doc, "MODPERSONA3")
      represented_entity_3 = { identifier: re_3_identifier, name: re_3_name, first_surname: re_3_first_surname, second_surname: re_3_second_surname, from: re_3_from, fiscal_year: re_3_fiscal_year, range_fund: re_3_range_fund, subvention: re_3_subvention, contract: re_3_contract, _destroy: re_3_destroy }
      represented_entities_attributes = { "1" => represented_entity_1, "2" => represented_entity_2, "3" => represented_entity_3 }

      #RepresentedEntity 4 (re_4)
      re_4_identifier     = key_content(doc, "DNI_REPRESENTA4")
      re_4_name           = key_content(doc, "NOMBRE_REPRESENTA4")
      re_4_first_surname  = key_content(doc, "APELLIDO1_REPRESENTA4")
      re_4_second_surname = key_content(doc, "APELLIDO4_REPRESENTA4")
      re_4_from           = key_content(doc, "FECHA_REPRESENTA4")
      re_4_fiscal_year    = key_content(doc, "EJERCICIO_REPRESENTA4")
      re_4_range_fund     = get_range_fund(doc, "FONDOS_REPRESENTA4")
      re_4_subvention     = get_boolean_field_value(doc, "ENTIDAD_AYUDA_REPRESENTA4")
      re_4_contract       = get_boolean_field_value(doc, "ENTIDAD_CON_REPRESENTA4")
      re_4_destroy        = get_destroy(doc, "MODPERSONA4")
      represented_entity_4 = { identifier: re_4_identifier, name: re_4_name, first_surname: re_4_first_surname, second_surname: re_4_second_surname, from: re_4_from, fiscal_year: re_4_fiscal_year, range_fund: re_4_range_fund, subvention: re_4_subvention, contract: re_4_contract, _destroy: re_4_destroy }
      represented_entities_attributes = { "1" => represented_entity_1, "2" => represented_entity_2, "3" => represented_entity_3, "4" => represented_entity_4 }

      doc.xpath("//formulario").each do |form|
        if form.xpath("nombre=876") #Alta
          organization = Organization.create(reference: reference, identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname, country: country, province: province, town: town, address_type: address_type, address: address, number_type: number_type, number: number, gateway: gateway, stairs: stairs, floor: floor, door: door, postal_code: postal_code, email: email, phones: phones, category: category, description: description,
                              registered_lobby_ids: registered_lobby_ids, web: web, fiscal_year: fiscal_year, range_fund: range_fund, contract: contract, subvention: subvention, check_email: check_email, check_sms: check_sms,
                              user_attributes: user_attributes, legal_representant_attributes: legal_representant_attributes, represented_entities_attributes: represented_entities_attributes)

        elsif form.xpath("nombre=877") #Modificación
          organization = Organization.where(identifier: doc.xpath("//interesado/documento").text).first
          user_attributes                 = check_user_attributes(organization, user_attributes)
          legal_representant_attributes   = check_legal_representant_attributes(legal_representant_attributes)
          represented_entities_attributes = check_represented_entities_attributes(doc, represented_entities_attributes)
          organization_params =  {reference: reference, identifier: identifier, name: name, first_surname: first_surname, second_surname: second_surname, country: country, province: province, town: town, address_type: address_type, address: address, number_type: number_type, number: number, gateway: gateway, stairs: stairs, floor: floor, door: door, postal_code: postal_code, email: email, phones: phones, category: category, description: description,
                              registered_lobby_ids: registered_lobby_ids, web: web, fiscal_year: fiscal_year, range_fund: range_fund, contract: contract, subvention: subvention, check_email: check_email, check_sms: check_sms,
                              user_attributes: user_attributes, legal_representant_attributes: legal_representant_attributes, represented_entities_attributes: represented_entities_attributes }
          UserMailer.welcome(organization.user).deliver_now if organization.user.email != user_attributes[:email]
          organization.update_attributes(organization_params)
        elsif form.xpath("nombre=878") #Baja
          organization = Organization.where(identifier: doc.xpath("//interesado/documento").text).first
          organization.update(canceled_at: DateTime.current)
          organization.user.soft_deleted
        else

        end
      end
      puts doc

      render soap: {
        codRetorno: "",
        descError: "OK",
        idExpediente: "idExpediente",
        refExpediente: "refExpediente",
      }
    end

    private

    # certain_term
    # code_of_conduct_term
    # created_at
    # updated_at
    # inscription_reference
    # inscription_date
    # entity_type
    # invalidated_at
    # canceled_at
    # invalidated_reasons
    # modification_date
    # gift_term
    # lobby_term

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
      category = nil
      if key_content(doc, "COMUNES_INTERESADO_CATEG").present?
        case key_content(doc, "COMUNES_INTERESADO_CATEG")
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
      if key_content(doc, "COMUNES_INTERESADO_INSCRIPCION") == "S"
        ids = []
        ids << RegisteredLobby.where(name: "generalitat_catalunya").first.id if key_content(doc, "COMUNES_INTERESADO_GENERAL") == true
        ids << RegisteredLobby.where(name: "cnmc").first.id                  if key_content(doc, "COMUNES_INTERESADO_CNMC") == true
        ids << RegisteredLobby.where(name: "europe_union").first.id          if key_content(doc, "COMUNES_INTERESADO_UE") == true
        ids << RegisteredLobby.where(name: "others").first.id                if key_content(doc, "COMUNES_INTERESADO_OTROS") == true
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
      (0...8).map { (65 + rand(26)).chr }.join
    end

    def get_boolean_field_value(doc, field)
      key_content(doc, field) == "S"
    end

    def get_check(doc, field)
      key_content(doc, field) == "true"
    end

    def check_user_attributes(organization, user_attributes)
      if user_attributes.count != user_attributes.compact.count && user_attributes.compact.count > 0
        user_attributes.compact!
      end
      if user_attributes[:email].present? && (organization.user.email == user_attributes[:email])
        user_attributes[:password] = nil
        user_attributes[:password_confirmation] = nil
        user_attributes[:id] = organization.user.id
        user_attributes.compact!
      end
      return user_attributes
    end

    def check_legal_representant_attributes(legal_representant_attributes)
      need_remove_blank_attributes = false
      legal_representant_attributes.each do |attribute|
        if attribute[1].present?
          need_remove_blank_attributes = true
        end
      end
      need_remove_blank_attributes ? legal_representant_attributes.compact! : legal_representant_attributes
    end

    def check_represented_entities_attributes(doc, represented_entities_attributes)
      represented_entities_attributes.each do |represented_entity|
        represented_entity[1].compact!
      end
      return represented_entities_attributes
    end

    # def destroy_represented_entities(doc)
    #   if key_content(doc, "MODPERSONA") == "baja"
    #     re = RepresentedEntity.where(identifier: key_content(doc, "DNI_REPRESENTA")).first
    #     re.destroy if re.present?
    #   end
    #   2..4.each do |id|
    #   if key_content(doc, "MODPERSONA#{id}") == "baja"
    #     re = RepresentedEntity.where(identifier: key_content(doc, "DNI_REPRESENTA#{id}")).first
    #     re.destroy if re.present?
    #   end
    # end
    #
    # def create_represented_entities(doc)
    #   if key_content(doc, "MODPERSONA") == "alta"
    #     re = RepresentedEntity.where(identifier: key_content(doc, "DNI_REPRESENTA")).first
    #     re.destroy if re.present?
    #   end
    #   2..4.each do |id|
    #   if key_content(doc, "MODPERSONA#{id}") == "baja"
    #     re = RepresentedEntity.where(identifier: key_content(doc, "DNI_REPRESENTA#{id}")).first
    #     re.destroy if re.present?
    #   end
    # end


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
      (key_content(doc, "field") == "baja") ? "1" : "false"
    end

  end
end
