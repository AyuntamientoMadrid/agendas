include ActionView::Helpers::SanitizeHelper

class OrganizationExporter

  ENUMS       = { range_fund: "organizations.show.range_fund", entity_type: "organizations.show.entity_type"}.freeze
  COLLECTIONS = { registered_lobbies: :name }.freeze
  STRIP_HTML_TAGS =  [:description].freeze

  FIELDS = ['reference', 'identifier', 'name', 'first_surname', 'second_surname',
            'address_type', 'address', 'number', 'gateway', 'stairs', 'floor',
            'door', 'postal_code', 'town', 'province', 'phones', 'email',
            'description', 'web', 'registered_lobbies', 'fiscal_year',
            'range_fund', 'subvention', 'contract', 'certain_term',
            'code_of_conduct_term', 'gift_term', 'lobby_term', 'inscription_reference', 'inscription_date',
            'entity_type', 'neighbourhood', 'district', 'scope',
            'associations_count', 'members_count', 'approach',
            'legal_representant_full_name', 'user_name', 'invalidated?'].freeze

  def headers
    FIELDS.map { |f| I18n.t("organization_exporter.#{f}") }
  end

  def organization_to_row(organization)
    FIELDS.map do |field|
      process_field(organization, field)
    end
  end

  def windows_headers
    windows_array headers
  end

  def windows_organization_row(organization)
    windows_array organization_to_row(organization)
  end

  def save_csv(path)
    CSV.open(path, 'w', col_sep: ';', encoding: "ISO-8859-1") do |csv|
      csv << windows_headers
      Organization.find_each do |organization|
        csv << windows_organization_row(organization)
      end
    end
  end

  def save_xls(path)
    Spreadsheet.client_encoding = 'ISO-8859-1'
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold
    sheet.row(0).concat headers
    index = 1
    Organization.find_each do |organization|
      sheet.row(index).concat windows_organization_row(organization)
      index += 1
    end

    book.write(path)
  end

  def save_json(path)
    data = []
    h = headers
    Organization.find_each do |organization|
      data << h.zip(organization_to_row(organization)).to_h
    end
    File.open(path, "w") do |f|
      f.write(data.to_json)
    end
  end

  private

    def windows_array(values)
      values.map { |v| v.to_s.encode("ISO-8859-1", invalid: :replace, undef: :replace, replace: '') }
    end

    def process_field(organization, field)
      if ENUMS.keys.include?(field.to_sym)
        I18n.t "#{ENUMS[field.to_sym]}.#{organization.send(field)}" if organization.send(field).present?
      elsif COLLECTIONS.keys.include?(field.to_sym)
        accessor = COLLECTIONS[field.to_sym]
        organization.send(field).collect(&accessor).join(", ")
      elsif organization.send(field).class == TrueClass || organization.send(field).class == FalseClass
        I18n.t "#{organization.send(field)}"
      elsif STRIP_HTML_TAGS.include?(field.to_sym)
        strip_tags(organization.send(field))
      else
        organization.send(field)
      end
    end
end
