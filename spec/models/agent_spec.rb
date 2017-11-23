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


end
