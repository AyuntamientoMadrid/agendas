class PublicOrganizationExporter
  FIELDS = ['reference', 'identifier', 'name', 'first_name', 'last_name',
            'address_type', 'address', 'number', 'gateway', 'stairs', 'floor',
            'door', 'postal_code', 'town', 'province', 'phones', 'email',
            'description', 'web', 'registered_lobbies', 'fiscal_year',
            'range_fund', 'subvention', 'contract', 'denied_public_data',
            'denied_public_events', 'inscription_reference', 'inscription_date',
            'entity_type', 'neighbourhood', 'district', 'scope',
            'associations_count', 'members_count', 'approach'].freeze

  def headers
    FIELDS.map { |f| I18n.t("public_organization_exporter.#{f}") }
  end

  def organization_to_row(organization)
    FIELDS.map do |f|
      organization.send(f)
    end
  end

  def windows_headers
    windows_array headers
  end

  def windows_organization_row(organization)
    windows_array organization_to_row(organization)
  end

  def save_csv(path)
    CSV.open(path, 'w', col_sep: ';', force_quotes: true, encoding: "ISO-8859-1") do |csv|
      csv << windows_headers
      Organization.find_each do |organization|
        csv << windows_organization_row(organization)
      end
    end
  end

  def save_xls(path)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold
    sheet.row(0).concat headers
    index = 1
    Organization.find_each do |organization|
      sheet.row(index).concat organization_to_row(organization)
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
end
