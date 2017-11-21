require 'rails_helper'

describe Organization do

  let(:organization) { build(:organization) }

  it "should be valid" do
    expect(organization).to be_valid
  end

end
