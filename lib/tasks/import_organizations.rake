require 'public_organization_importer'
namespace :import_organizations do

  desc "Import organizations (associations) from remote csv"
  task associations: :environment do
    PublicOrganizationImporter.parse_associations
  end

  desc "Import organizations (federations) from remote csv"
  task federations: :environment do
    PublicOrganizationImporter.parse_federations
  end

end
