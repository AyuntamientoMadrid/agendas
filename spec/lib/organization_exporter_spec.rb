require 'rails_helper'
require 'organization_exporter'

describe OrganizationExporter do
  let(:exporter) { OrganizationExporter.new }

  describe '#headers' do
    it "generates localized headers" do
      expect(exporter.headers.first).to eq('referencia')
      expect(exporter.headers.last).to eq('invalidada')
    end
  end

  describe '#organization_to_row' do
    it "generates a row of info based on a public organization" do
      o = create(:organization, subvention: true, contract: true, certain_term: true,
                 code_of_conduct_term: true, gift_term: true, lobby_term: true,
               inscription_reference: "ref232", description: "No more html tags <bold>tags</bold>")
      l = create(:legal_representant, organization: o)

      row = exporter.organization_to_row(o)

      expect(row[0]).to eq(o.reference)
      expect(row[1]).to eq(o.identifier)
      expect(row[2]).to eq(o.name)
      expect(row[3]).to eq(o.first_surname)
      expect(row[4]).to eq(o.second_surname)
      expect(row[5]).to eq(o.address_type)
      expect(row[6]).to eq(o.address)
      expect(row[7]).to eq(o.number)
      expect(row[8]).to eq(o.gateway)
      expect(row[9]).to eq(o.stairs)
      expect(row[10]).to eq(o.floor)
      expect(row[11]).to eq(o.door)
      expect(row[12]).to eq(o.postal_code)
      expect(row[13]).to eq(o.town)
      expect(row[14]).to eq(o.province)
      expect(row[15]).to eq(o.phones)
      expect(row[16]).to eq(o.email)
      expect(row[17]).to eq("No more html tags tags")
      expect(row[18]).to eq(o.web)
      expect(row[19]).to eq(o.registered_lobbies.collect(&:name).join(", "))
      expect(row[20]).to eq(o.fiscal_year)
      expect(row[21]).to eq("Inferiores a 9.999 euros")
      expect(row[22]).to eq("Sí")
      expect(row[23]).to eq("Sí")
      expect(row[24]).to eq("Sí")
      expect(row[25]).to eq("Sí")
      expect(row[26]).to eq("Sí")
      expect(row[27]).to eq("Sí")
      expect(row[28]).to eq(o.inscription_reference)
      expect(row[29]).to eq(o.inscription_date)
      expect(row[30]).to eq("Lobby")
      expect(row[31]).to eq(o.neighbourhood)
      expect(row[32]).to eq(o.district)
      expect(row[33]).to eq(o.scope)
      expect(row[34]).to eq(o.associations_count)
      expect(row[35]).to eq(o.members_count)
      expect(row[36]).to eq(o.approach)
      expect(row[37]).to include(o.legal_representant.fullname)
      expect(row[38]).to eq(o.user.full_name)
      expect(row[39]).to eq("No")
    end
  end

end
