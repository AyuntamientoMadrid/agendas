require 'rails_helper'

RSpec.describe Attendee, type: :model do

  it "should be invalid if no name" do
    @attendee = FactoryGirl.build(:attendee, name: nil)
    expect(@attendee).not_to be_valid
  end

  it "should be invalid if no company" do
    @attendee = FactoryGirl.build(:attendee, company: nil)
    expect(@attendee).not_to be_valid
  end

  it "should be invalid if no position" do
    @attendee = FactoryGirl.build(:attendee, position: nil)
    expect(@attendee).not_to be_valid
  end

  it "should be valid if name company and position present" do
    expect(FactoryGirl.build(:attendee)).to be_valid
  end


end
