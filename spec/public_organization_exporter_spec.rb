require 'rails_helper'
require 'public_organization_exporter'

describe PublicOrganizationExporter do
  let(:exporter) { PublicOrganizationExporter.new }

  describe '#headers' do
    it "generates localized headers" do
      expect(exporter.headers.first).to eq('referencia')
      expect(exporter.headers.last).to eq('nombre y apellidos')
    end
  end

  describe '#public_organization_to_row' do
    it "generates a row of info based on a public organization" do
      o = create(:organization)
      l = create(:legal_representant)
      o.legal_representant = l

      row = exporter.organization_to_row(o)

      expect(row).to include(o.reference)
      expect(row).to include(o.identifier)
      expect(row).to include(o.address_type)
      expect(row).to include(o.address)
      expect(row).to include(o.number)
      expect(row).to include(o.stairs)
      expect(row).to include(o.floor)
      expect(row).to include(o.door)
      expect(row).to include(o.postal_code)
      expect(row).to include(o.town)
      expect(row).to include(o.province)
      expect(row).to include(o.phones)
      expect(row).to include(o.email)
      expect(row).to include(o.web)
      expect(row).to include(o.registered_lobbies)
      expect(row).to include(o.fiscal_year)
      expect(row).to include(o.range_fund)
      expect(row).to include(o.subvention)
      expect(row).to include(o.contract)
      expect(row).to include(o.denied_public_data)
      expect(row).to include(o.denied_public_events)
      expect(row).to include(o.entity_type)
      expect(row).to include(nil)
      expect(row).to include(o.user.full_name)

      l = create(:legal_representant)
      o.legal_representant = l

      row = exporter.organization_to_row(o)

      expect(row).to include(o.legal_representant.fullname)

    end
  end

end
