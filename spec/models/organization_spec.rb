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

  it "should be valid" do
    expect(organization).to be_valid
  end

  it "should not be valid when inscription_reference already exists" do
    organization = create(:organization, inscription_reference: "XYZ")
    another_organization = build(:organization, inscription_reference: "XYZ")

    expect(another_organization).not_to be_valid
  end

end
