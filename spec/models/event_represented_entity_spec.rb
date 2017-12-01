require 'rails_helper'

describe EventRepresentedEntity do

  let(:event_represented_entity) { build(:event_represented_entity) }

  it "should be valid" do
    expect(event_represented_entity).to be_valid
  end

  it "should not be valid without name" do
    event_represented_entity.name = nil

    expect(event_represented_entity).not_to be_valid
  end

end
