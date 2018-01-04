require 'rails_helper'
require 'organization_exporter'

describe OrganizationExporter do
  let(:exporter) { OrganizationExporter.new }

  describe '#headers' do
    it "generates localized headers" do
      expect(exporter.headers.first).to eq('referencia')
      expect(exporter.headers.last).to eq('Áreas de interés')
    end
  end

  describe '#organization_to_row' do
    it "generates a row of info based on a public organization" do
      organization = create(:organization, subvention: true, contract: true, certain_term: true,
                            code_of_conduct_term: true, gift_term: true, lobby_term: true,
                            inscription_reference: "ref232", description: "No more html tags <bold>tags</bold>")
      create(:legal_representant, organization: organization)
      create(:agent, organization: organization)
      create(:represented_entity, organization: organization)
      create(:organization_interest, organization: organization)

      row = exporter.organization_to_row(organization)

      expect(row[0]).to eq(organization.reference)
      expect(row[1]).to eq(organization.identifier)
      expect(row[2]).to eq(organization.name)
      expect(row[3]).to eq(organization.first_surname)
      expect(row[4]).to eq(organization.second_surname)
      expect(row[5]).to eq(organization.address_type)
      expect(row[6]).to eq(organization.address)
      expect(row[7]).to eq(organization.number)
      expect(row[8]).to eq(organization.gateway)
      expect(row[9]).to eq(organization.stairs)
      expect(row[10]).to eq(organization.floor)
      expect(row[11]).to eq(organization.door)
      expect(row[12]).to eq(organization.postal_code)
      expect(row[13]).to eq(organization.town)
      expect(row[14]).to eq(organization.province)
      expect(row[15]).to eq(organization.phones)
      expect(row[16]).to eq(organization.email)
      expect(row[17]).to eq("No more html tags tags")
      expect(row[18]).to eq(organization.web)
      expect(row[19]).to eq(organization.registered_lobbies.collect(&:name).join(", "))
      expect(row[20]).to eq(organization.fiscal_year)
      expect(row[21]).to eq("Inferiores a 9.999 euros")
      expect(row[22]).to eq("Sí")
      expect(row[23]).to eq("Sí")
      expect(row[24]).to eq("Sí")
      expect(row[25]).to eq("Sí")
      expect(row[26]).to eq("Sí")
      expect(row[27]).to eq("Sí")
      expect(row[28]).to eq(organization.inscription_reference)
      expect(row[29]).to eq(organization.inscription_date)
      expect(row[30]).to eq("Lobby")
      expect(row[31]).to eq(organization.neighbourhood)
      expect(row[32]).to eq(organization.district)
      expect(row[33]).to eq(organization.scope)
      expect(row[34]).to eq(organization.associations_count)
      expect(row[35]).to eq(organization.members_count)
      expect(row[36]).to eq(organization.approach)
      expect(row[37]).to eq(organization.legal_representant.fullname)
      expect(row[38]).to eq(organization.user.full_name)
      expect(row[39]).to eq("No")
      expect(row[40]).to eq(organization.agents.first.fullname)
      expect(row[41]).to eq(organization.represented_entities.first.fullname)
      expect(row[42]).to eq(organization.interests.first.name)
    end
  end

end
