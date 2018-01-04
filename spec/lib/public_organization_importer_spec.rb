require 'rails_helper'
require 'public_organization_importer'

describe PublicOrganizationImporter do
  let(:importer) { PublicOrganizationImporter }

  describe 'read csv' do
    it "it does nothing without the csv" do
      PublicOrganizationImporter.stub(:get_file).and_return(nil)
      expect(importer.parse_associations).to eq(nil)
    end

    it "it creates correct associations" do
      file_route = Rails.root.join('spec', 'fixtures', 'associations.csv')
      PublicOrganizationImporter.stub(:get_file).and_return(File.open(file_route).read)
      PublicOrganizationImporter.parse_associations
      association = Organization.last
      expect(association.entity_type).to eq('association')
    end

    it "it creates correct federations" do
      file_route = Rails.root.join('spec', 'fixtures', 'federations.csv')
      PublicOrganizationImporter.stub(:get_file).and_return(File.open(file_route).read)
      PublicOrganizationImporter.parse_federations
      federation = Organization.last
      expect(federation.entity_type).to eq('federation')
    end

  end

end
