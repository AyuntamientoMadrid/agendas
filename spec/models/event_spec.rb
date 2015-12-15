require 'rails_helper'

RSpec.describe Event, type: :model do

  before do
    @event = FactoryGirl.create(:event)
  end

  it "should be invalid if no title" do
    @event.title = nil
    expect(@event).not_to be_valid
  end


  it "should be invalid if participant are not unique" do
    participant = FactoryGirl.create(:participant)
    2.times do
      @event.participants << participant
    end
    expect(@event).not_to be_valid
  end

  it "should not be allowed assign participant more than once to event" do
  end


end
