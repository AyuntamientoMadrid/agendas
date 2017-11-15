require 'rails_helper'

describe Manage do

  let(:manage) { build(:manage) }

  it "should be valid" do
    expect(manage).to be_valid
  end

end
