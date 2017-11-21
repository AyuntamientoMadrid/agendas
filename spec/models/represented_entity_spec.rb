require 'rails_helper'

describe RepresentedEntity do

  let(:represented_entity) { build(:represented_entity) }

  it "should be valid" do
    expect(represented_entity).to be_valid
  end

end
