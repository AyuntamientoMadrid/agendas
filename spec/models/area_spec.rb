require 'rails_helper'

describe Area do

  let(:area) { build(:area) }

  it "should not be valid without title defined" do
    area.title = nil

    expect(area.valid?).to be false
  end

  it "should be active when created" do
    area.save

    expect(area.active).to be
  end

  it "should be active if parent is set to active" do
    area.active = true
    area.save
    child_area = create(:area, parent: area)

    expect(child_area.active).to be
  end

  it "should be inactive if parent is set to inactive" do
    area.active = false
    area.save
    child_area = create(:area, parent: area)

    expect(child_area.active).not_to be true
  end

  describe "#update_children callback" do
    it "should update all children to true" do
      area.active = false
      area.save
      child_area = create(:area, parent: area)

      area.update(active: true)

      expect(child_area.active).to be
    end

    it "should update all children to false" do
      area.active = true
      area.save
      child_area = create(:area, parent: area)

      area.update(active: false)

      expect(child_area.active).not_to be true
    end
  end

end
