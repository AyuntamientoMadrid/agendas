require 'rails_helper'

describe Agent do

  let(:agent) { build(:agent) }

  it "should be valid" do
    expect(agent).to be_valid
  end

  it "should not be valid whitout name" do
    agent.name = nil

    expect(agent).not_to be_valid
  end

  it "should not be valid whitout identifier" do
    agent.identifier = nil

    expect(agent).not_to be_valid
  end

  it "should not be valid whitout from" do
    agent.from = nil

    expect(agent).not_to be_valid
  end

  describe "#fullname" do
    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = ""
      agent.second_surname = ""

      expect(agent.fullname).to eq "Name"
    end

    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = "FirstSurname"
      agent.second_surname = ""

      expect(agent.fullname).to eq "Name FirstSurname"
    end

    it "Should return first_surname and second_surname when they are defined" do
      agent.name = "Name"
      agent.first_surname = "FirstSurname"
      agent.second_surname = "SecondSurname"

      expect(agent.fullname).to eq "Name FirstSurname SecondSurname"
    end
  end

end
