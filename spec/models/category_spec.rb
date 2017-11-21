require 'rails_helper'

describe Category do

  let(:category) { build(:category) }

  it "should be valid" do
    expect(category).to be_valid
  end

end
