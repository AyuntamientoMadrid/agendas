require 'rails_helper'

describe Organization do

  let(:organization) { build(:organization) }

  it { should respond_to(:generalitat_catalunya?) }
  it { should respond_to(:cnmc?) }
  it { should respond_to(:europe_union?) }
  it { should respond_to(:others?) }

  it { should respond_to(:range_1?) }
  it { should respond_to(:range_2?) }
  it { should respond_to(:range_3?) }
  it { should respond_to(:range_4?) }

  it { should respond_to(:federation?) }
  it { should respond_to(:association?) }
  it { should respond_to(:lobby?) }

  it "Should be valid" do
    expect(organization).to be_valid
  end

  it "Should not be valid when inscription_reference already exists" do
    create(:organization, inscription_reference: "XYZ")
    another_organization = build(:organization, inscription_reference: "XYZ")

    expect(another_organization).not_to be_valid
  end

  it "should not be valid whitout name" do
    organization.name = nil

    expect(organization).not_to be_valid
  end

  it "should be valid whitout user" do
    #It changed due to the inclusion of Associations and Federations
    organization.user = nil

    expect(organization).to be_valid
  end

  it "should not be valid without category defined" do
    organization.category = nil

    expect(organization).not_to be_valid
  end

  describe "#fullname" do
    it "Should return first_surname and second_surname when they are defined" do
      organization.name = "Name"
      organization.first_surname = ""
      organization.second_surname = ""

      expect(organization.fullname).to eq "Name"
    end

    it "Should return first_surname and second_surname when they are defined" do
      organization.name = "Name"
      organization.first_surname = "FirstSurname"
      organization.second_surname = ""

      expect(organization.fullname).to eq "Name FirstSurname"
    end

    it "Should return first_surname and second_surname when they are defined" do
      organization.name = "Name"
      organization.first_surname = "FirstSurname"
      organization.second_surname = "SecondSurname"

      expect(organization.fullname).to eq "Name FirstSurname SecondSurname"
    end
  end

  it "should have a correct legal representant full name" do
    legal_representant = build(:legal_representant)
    organization.legal_representant = legal_representant
    legal_representant_full_name = organization.legal_representant.fullname

    expect(organization.legal_representant_full_name).to eq(legal_representant_full_name)
  end

  describe "#set_inscription_date" do

    it "should set inscription_date with current date" do
      organization.inscription_date = nil

      organization.save

      expect(organization.inscription_date).to eq(Date.current)
    end

    it "should not set inscription_date" do
      organization.inscription_date = Date.yesterday

      organization.save

      expect(organization.inscription_date).to eq(Date.yesterday)
    end

  end

end
