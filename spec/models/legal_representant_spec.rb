require 'rails_helper'

describe LegalRepresentant do

  let(:legal_representant) { build(:legal_representant) }

  it "should have a correct fullname" do
    fullname = "#{legal_representant.name} #{legal_representant.first_surname} #{legal_representant.second_surname}"

    expect(legal_representant.fullname).to eq(fullname)
  end

  it "should be valid" do
    expect(legal_representant).to be_valid
  end

  it "should not be valid whitout name" do
    legal_representant.name = nil

    expect(legal_representant).not_to be_valid
  end

  it "should not be valid whitout identifier" do
    legal_representant.identifier = nil

    expect(legal_representant).not_to be_valid
  end

  it "should not be valid whitout first_surname" do
    legal_representant.first_surname = nil

    expect(legal_representant).not_to be_valid
  end

  it "should not be valid whitout email" do
    legal_representant.email = nil

    expect(legal_representant).not_to be_valid
  end

end
