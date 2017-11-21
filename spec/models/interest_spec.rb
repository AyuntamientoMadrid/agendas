require 'rails_helper'

describe Interest do

  let(:interest) { build(:interest) }

  it "should be valid" do
    expect(interest).to be_valid
  end

end
