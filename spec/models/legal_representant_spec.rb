require 'rails_helper'

describe LegalRepresentant do

  let(:legal_representant) { build(:legal_representant) }

  it "should be valid" do
    expect(legal_representant).to be_valid
  end

end
