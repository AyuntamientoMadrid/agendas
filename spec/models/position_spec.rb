require 'rails_helper'

RSpec.describe Position, type: :model do

  it "should be invalid if no title" do
    @position = FactoryGirl.build(:position, title: nil)
    expect(@position).not_to be_valid
  end

  it "should be invalid if no area" do
    @position = FactoryGirl.build(:position, area: nil)
    expect(@position).not_to be_valid
  end

  it "should be invalid if no from" do
    @position = FactoryGirl.build(:position, from: nil, to: nil)
    expect(@position).not_to be_valid
  end

  it "should be invalid if from date greater then to date" do
    @position = FactoryGirl.build(:position, from: Time.now, to: Time.now - 1)
    expect(@position).not_to be_valid
  end

  it "should be valid if title from and area are present" do
    expect(FactoryGirl.build(:position)).to be_valid
  end

end
