require 'rails_helper'

describe RepresentedEntity do

  let(:represented_entity) { build(:represented_entity) }

  it "should be valid" do
    expect(represented_entity).to be_valid
  end

  it "should not be valid whitout name" do
    represented_entity.name = nil

    expect(represented_entity).not_to be_valid
  end

  it "should not be valid whitout identifier" do
    represented_entity.identifier = nil

    expect(represented_entity).not_to be_valid
  end

  it "should not be valid whitout from" do
    represented_entity.from = nil

    expect(represented_entity).not_to be_valid
  end

  it "should not be valid whitout fiscal_year" do
    represented_entity.fiscal_year = nil

    expect(represented_entity).not_to be_valid
  end

  describe "#fullname" do
    it "Should return first_surname and second_surname when they are defined" do
      represented_entity.name = "Name"
      represented_entity.first_surname = ""
      represented_entity.second_surname = ""

      expect(represented_entity.fullname).to eq "Name"
    end

    it "Should return first_surname and second_surname when they are defined" do
      represented_entity.name = "Name"
      represented_entity.first_surname = "FirstSurname"
      represented_entity.second_surname = ""

      expect(represented_entity.fullname).to eq "Name FirstSurname"
    end

    it "Should return first_surname and second_surname when they are defined" do
      represented_entity.name = "Name"
      represented_entity.first_surname = "FirstSurname"
      represented_entity.second_surname = "SecondSurname"

      expect(represented_entity.fullname).to eq "Name FirstSurname SecondSurname"
    end
  end

  describe "scopes" do

    describe "by_organization" do

      it "should return all represented_entities by organization" do
        organization = create(:organization)
        represented_entity_1 = create(:represented_entity, organization: organization)
        represented_entity_2 = create(:represented_entity, organization: organization)

        represented_entities = RepresentedEntity.by_organization(organization)

        expect(represented_entities.count).to eq(2)
        expect(represented_entities).to include represented_entity_1
        expect(represented_entities).to include represented_entity_2
      end

    end

  end

end
