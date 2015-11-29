require 'rails_helper'

RSpec.describe Area, type: :model do

  before do
    @area = FactoryGirl.create(:area)
  end

  it "should be active when created" do
    expect(@area.active).to be
  end

  it "should be active if parent is set to active" do
    area = FactoryGirl.create(:area, parent: @area)
    @area.update_attributes(active: true)
    expect(area.active).to  be
  end

  it "should be inactive if parent is set to inactive" do
    area = FactoryGirl.create(:area, parent: @area)
    @area.update_attributes(active: false)
    expect(area.active).not_to be true
  end


end
