require 'rails_helper'

RSpec.describe Participant, type: :model do

  before do
    @event = FactoryGirl.build_stubbed(:event)
    @position = FactoryGirl.build_stubbed(:position)
  end

  it "should be invalid if no position" do
    participant = FactoryGirl.build(:participant, event: @event)
    expect(participant).not_to be_valid
  end

  it "should be invalid if no event" do
    participant = FactoryGirl.build(:participant, position: @position)
    expect(participant).not_to be_valid
  end

  it "should be valid if event and position are present" do
    participant = FactoryGirl.build(:participant, position: @position, event: @event)
    expect(participant).to be_valid
  end

  it "should not be allowed assign participant more than once to event" do
    participant = FactoryGirl.build_stubbed(:participant, position: @position, event: @event)
    expect(participant).to be_valid
    participant2 = FactoryGirl.build(:participant, position: @position, event: @event)
    expect(participant2).not_to be_valid

  end


end
