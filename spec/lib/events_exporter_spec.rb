require 'rails_helper'
require 'events_exporter'

describe EventsExporter do

  describe "when is in default mode" do

    let(:exporter) { EventsExporter.new }

    describe "#headers" do

      it "Should contain eight colums headers" do
        expect(exporter.headers.size).to eq(8)
      end

      it "Should return correct headers translations" do
        exporter.fields.each_with_index do |field, index|
          expect(exporter.headers[index]).to eq(I18n.t("events_exporter.#{field}"))
        end
      end
    end

    describe '#events_to_row' do
      it "Should return array of public events" do
        position = create(:position)
        event = create(:event, organization_name: "Organization name", position: position,
                       accepted_at: Time.zone.now - 1.hour, published_at: Time.zone.now - 1.hour)

        row = exporter.event_to_row(event)

        expect(row).to include(event.title)
        expect(row).to include(event.description)
        expect(row).to include(I18n.l(event.scheduled, format: :short))
        expect(row).to include(I18n.l(event.updated_at, format: :short))
        expect(row).to include(event.position_names)
        expect(row).to include(event.location)
        expect(row).to include(event.organization_name)
      end
    end
  end

  describe "when is in extended mode" do

    let(:exporter) { EventsExporter.new true }

    describe "#headers" do

      it "Should contain twenty-four colums headers" do
        expect(exporter.headers.size).to eq(24)
      end

      it "Should return correct headers translations" do
        exporter.fields.each_with_index do |field, index|
          expect(exporter.headers[index]).to eq(I18n.t("events_exporter.#{field}"))
        end
      end
    end

    describe '#events_to_row' do
      it "Should return array of public events" do
        position = create(:position)
        event = create(:event, organization_name: "Organization name", position: position,
                       accepted_at: Time.zone.now - 1.hour, published_at: Time.zone.now - 1.hour)

        row = exporter.event_to_row(event)

        expect(row).to include(event.title)
        expect(row).to include(event.description)
        expect(row).to include(I18n.l(event.scheduled, format: :short))
        expect(row).to include(I18n.l(event.updated_at, format: :short))
        expect(row).to include(event.position_names)
        expect(row).to include(event.location)
        expect(row).to include("Aceptado")
        expect(row).to include(event.notes)
        expect(row).to include(event.canceled_reasons)
        expect(row).to include(I18n.l(event.published_at, format: :short))
        expect(row).to include(I18n.l(event.canceled_at, format: :short)) if event.canceled_at.present?
        expect(row).to include(I18n.l(event.accepted_at, format: :short))
        expect(row).to include(I18n.l(event.declined_at, format: :short)) if event.declined_at.present?
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
end
