require 'rails_helper'

describe EventAgent do

  let(:event_agent) { build(:event_agent) }

  it "should be valid" do
    expect(event_agent).to be_valid
  end

  it "should not be valid without name" do
    event_agent.name = nil

    expect(event_agent).not_to be_valid
  end

end
