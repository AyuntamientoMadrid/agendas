class PublicOrganizationImporter

  def self.parse_associations
    parse(Rails.application.config.associations_csv_url, associations_mapping)
  end

  def self.parse_federations
    parse(Rails.application.config.federations_csv_url, federations_mapping)
  end

  def self.parse(url, type_mapping)
    file = get_file(url)
    return unless file
    CSV.new(file, col_sep: ";", quote_char: '"', headers: true).each do |line|
      data = line.to_hash
      organization = Organization.new("entity_type" => type_mapping["entity_type"])
      common_mapping.each do |org, csv|
        organization[org] =  data[csv]
      end
      type_mapping["fields"].each do |org, csv|
        organization[org] = data[csv]
      end
      organization.category = get_category(data)
      begin
        organization.save!
      rescue
        # ignore errors, for now
      end
    end
  end

  def self.get_file(url)
    begin
      File.open(open(url), "r:iso-8859-1:utf-8").read
    rescue
      # ignore file issues, mostily url troubles
    end
  end

  def self.get_category(data)
    Category.find_or_create_by(name: data["Categoría"], display: false)
  end

  def self.associations_mapping
    { "entity_type" => 0,
      "fields" => { "neighbourhood" => "Barrio",
                    "district" => "Distrito" } }
  end

  def self.federations_mapping
    { "entity_type" => 1,
      "fields" => { "associations_count" => "Asoc. Totales",
                    "members_count" => "Socios Totales" } }
  end

  def self.common_mapping
    { "inscription_reference" => "Num. Inscripción",
      "identifier" => "CIF",
      "name" => "Razón Social",
      "address_type" => "Tipo Vía",
      "address" => "Calle",
      "number" => "Número",
      "postal_code" => "Cod. Postal",
      "town" => "Población",
      "phones" => "Primer Telf.",
      "email" => "Email",
      "web" => "Internet",
      "inscription_date" => "Fecha Registro",
      "scope" => "Ambito",
      "approach" => "Aproximación" }
  end

  private_class_method :parse, :get_file, :get_category, :associations_mapping,
                       :federations_mapping, :common_mapping

end
