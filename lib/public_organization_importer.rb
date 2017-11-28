class PublicOrganizationImporter

  def self.parse_associations
    parse(associations_url, associations_mapping)
  end

  def self.parse_federations
    parse(federations_url, federations_mapping)
  end

  private

    def self.associations_url
      "http://datos.madrid.es/egob/catalogo/206117-0-entidades-participacion-ciudadan.csv"
    end

    def self.federations_url
      "http://datos.madrid.es/egob/catalogo/202781-0-entidades-participacion-ciudadan.csv"
    end

    def self.parse(url, type_mapping)
      file = get_file(url)
      if file
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
            #ignore errors, for now
          end
        end
      end
    end

    def self.get_file(url)
      begin
        File.open(open(url), "r:iso-8859-1:utf-8").read
      rescue
        #ignore file issues, mostily url troubles
      end
    end

    def self.get_category(data)
      Category.find_or_create_by(name: data["Categoría"])
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

end
