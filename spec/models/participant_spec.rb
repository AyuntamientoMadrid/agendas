require 'rails_helper'

RSpec.describe Participant, type: :model do

  before do
    @event = FactoryGirl.create(:event)
    @position = FactoryGirl.create(:position)
  end

  it "should be invalid if no position" do
    participant = FactoryGirl.build(:participant, event: @event, position: nil)
    p participant
    expect(participant).not_to be_valid
  end

  it "should be invalid if no event" do
    participant = FactoryGirl.build(:participant, position: @position, event: nil)
    expect(participant).not_to be_valid
  end

  it "should be valid if event and position are present" do
    participant = FactoryGirl.build(:participant, position: @position, event: @event)
    expect(participant).to be_valid
  end

  it "should not be allowed assign participant more than once to event" do
    participant = FactoryGirl.create(:participant, position: @position, event: @event)
    expect(participant).to be_valid
    participant2 = FactoryGirl.build(:participant, position: @position, event: @event)
    expect(participant2).not_to be_valid
  end


end
