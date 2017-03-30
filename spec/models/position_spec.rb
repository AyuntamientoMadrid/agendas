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
end
