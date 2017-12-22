require 'spec_helper'

describe "import_organizations:federations" do

  include_context "rake"

  before do
    file_route = Rails.root.join('spec', 'fixtures', 'federations.csv')
    allow(PublicOrganizationImporter).to receive(:get_file).and_return(File.open(file_route).read)
  end

  it "check integrity and type of the imported organization" do
    subject.invoke

    federation = Organization.last
    expect(federation.entity_type).to eq('federation')
  end
end

describe "import_organizations:associations" do
  include_context "rake"

  before do
    file_route = Rails.root.join('spec', 'fixtures', 'associations.csv')
    allow(PublicOrganizationImporter).to receive(:get_file).and_return(File.open(file_route).read)
  end

  it "check integrity and type of the imported organization" do
    subject.invoke

    federation = Organization.last
    expect(federation.entity_type).to eq('association')
  end
end

