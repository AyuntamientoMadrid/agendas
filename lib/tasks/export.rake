require 'public_organization_exporter'
require 'fileutils'

namespace :export do
  desc "Exports organizations to public/export/public_organizations.csv,
        public/export/public_organizations.xls and public/export/public_organizations.json"
  task organizations: :environment do
    folder = Rails.root.join('public', 'export')
    FileUtils.rm_rf folder
    FileUtils.mkdir_p folder

    exporter = PublicOrganizationExporter.new

    exporter.save_csv(folder.join('public_organizations.csv'))
    exporter.save_xls(folder.join('public_organizations.xls'))
    exporter.save_json(folder.join('public_organizations.json'))
  end

  desc "Exports organizations' events to public/export/organizations_events.csv,
        public/export/organizations_events.xls and public/export/organizations_events.json"
  task events: :environment do
    folder = Rails.root.join('public', 'export')
    FileUtils.rm_rf folder
    FileUtils.mkdir_p folder

    exporter = EventsExporter.new

    exporter.save_csv(folder.join('organizations_events.csv'))
    exporter.save_xls(folder.join('organizations_events.xls'))
    exporter.save_json(folder.join('organizations_events.json'))
  end

end
