require 'rails_helper'

describe Agent do

  let(:agent) { build(:agent) }

  it "should be valid" do
    expect(agent).to be_valid
  end

end
