require 'organization_exporter'
require 'fileutils'

namespace :export do
  desc "Exports organizations to public/export/lobbies.csv,
        public/export/lobbies.xls and public/export/lobbies.json"
  task organizations: :environment do
    folder = Rails.root.join('public', 'export')
    FileUtils.mkdir_p folder unless Dir.exist?(folder)

    exporter = OrganizationExporter.new

    exporter.save_csv(folder.join('lobbies.csv'))
    exporter.save_xls(folder.join('lobbies.xls'))
    exporter.save_json(folder.join('lobbies.json'))
  end

  desc "Exports organizations' events to public/export/agendas.csv,
        public/export/agendas.xls and public/export/agendas.json"
  task agendas: :environment do
    folder = Rails.root.join('public', 'export')
    FileUtils.mkdir_p folder unless Dir.exist?(folder)

    exporter = EventsExporter.new

    exporter.save_csv(folder.join('agendas.csv'))
    exporter.save_xls(folder.join('agendas.xls'))
    exporter.save_json(folder.join('agendas.json'))
  end

end
