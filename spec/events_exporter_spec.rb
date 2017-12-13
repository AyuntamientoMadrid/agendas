require 'rails_helper'
require 'events_exporter'

describe EventsExporter do
  let(:exporter) { EventsExporter.new }

  describe '#headers' do
    it "generates localized headers" do
      expect(exporter.headers.first).to eq('título')
      expect(exporter.headers.last).to eq('observaciones generales del gestor')
    end
  end

  describe '#events_to_row' do
    it "generates a row of info based on a event" do
      position = create(:position)
      event = create(:event, organization_name: "Organization name", position: position)

      row = exporter.event_to_row(event)

      expect(row).to include(event.title)
      expect(row).to include(event.description)
      expect(row).to include(event.scheduled)
      expect(row).to include(event.updated_at)
      expect(row).to include(event.user_name)
      expect(row).to include(event.position_names)
      expect(row).to include(event.location)
      expect(row).to include(event.status)
      expect(row).to include(event.notes)
      expect(row).to include(event.reasons)
      expect(row).to include(event.published_at)
      expect(row).to include(event.canceled_at)
      expect(row).to include(event.organization_name)
      expect(row).to include(event.lobby_scheduled)
      expect(row).to include(event.general_remarks)
      expect(row).to include(event.lobby_contact_firstname)
      expect(row).to include(event.lobby_contact_lastname)
      expect(row).to include(event.lobby_scheduled)
      expect(row).to include(event.general_remarks)
      expect(row).to include(event.lobby_contact_phone)
      expect(row).to include(event.manager_general_remarks)

    end
  end

end
