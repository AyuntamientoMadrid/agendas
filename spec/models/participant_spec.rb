require 'rails_helper'

describe Participant do

  let(:participant) { build(:participant) }

  it "should valid" do
    expect(participant).to be_valid
  end

end
