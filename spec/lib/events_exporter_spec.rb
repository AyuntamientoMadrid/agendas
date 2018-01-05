require 'rails_helper'
require 'events_exporter'

describe EventsExporter do
  let(:exporter) { EventsExporter.new }

  describe "#headers" do

    it "Should contain twenty-five colums headers" do
      expect(exporter.headers.size).to eq(25)
    end

    it "Should return correct headers translations" do
      EventsExporter::FIELDS.each_with_index do |field, index|
        expect(exporter.headers[index]).to eq(I18n.t("events_exporter.#{field}"))
      end
    end
  end

  describe '#events_to_row' do
    it "Should return array of public events" do
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
      expect(row).to include("Aceptado")
      expect(row).to include(event.notes)
      expect(row).to include(event.canceled_reasons)
      expect(row).to include(event.published_at)
      expect(row).to include(event.canceled_at)
      expect(row).to include(event.accepted_at)
      expect(row).to include(event.declined_at)
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
