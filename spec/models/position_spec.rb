require 'rails_helper'

describe Position do

  let!(:position) { build(:position) }

  it "should be invalid if no title" do
    position.title = nil

    expect(position).not_to be_valid
  end

  it "should be invalid if no area" do
    position.area = nil

    expect(position).not_to be_valid
  end

  describe ".current" do
    let!(:position) { create(:position) }
    let!(:position2) { create(:position, to: Date.current) }

    it "Should return only current positions" do
      expect(Position.current).to eq([position])
    end
  end

  describe ".previous" do
    let!(:position) { create(:position) }
    let!(:position2) { create(:position, to: Date.current) }

    it "Should return only previous positions" do
      expect(Position.current).to eq([position])
    end
  end

  describe ".area_filtered" do
    let!(:area)                   { create(:area) }
    let!(:child_area)             { create(:area, parent: area) }
    let!(:position_parent_area)   { create(:position, area: area) }
    let!(:position_child_area)    { create(:position, area: child_area) }
    let!(:position_on_other_area) { create(:position) }

    it "Should return all positions in given parent area tree" do
      expect(Position.area_filtered(area.id)).to include(position_parent_area)
      expect(Position.area_filtered(area.id)).to include(position_child_area)
      expect(Position.area_filtered(area.id)).not_to include(position_on_other_area)
    end

    it "Should return all positions in given child area tree" do
      expect(Position.area_filtered(child_area.id)).to include(position_child_area)
      expect(Position.area_filtered(child_area.id)).not_to include(position_parent_area)
      expect(Position.area_filtered(child_area.id)).not_to include(position_on_other_area)
    end
  end

  describe "#events" do
    let!(:other_event) { create(:event) }
    let!(:event)       { create(:event) }
    let!(:position)    { event.position }
    let!(:participant) { create(:participant, participants_event: event, position: position) }

    it "Should return unique events where position is holder or participant" do
      expect(position.events).to include(event)
      expect(position.events).not_to include(other_event)
    end

    it "Should return all events where position is holder or participant" do
      event_as_participant = create(:event)
      create(:participant, participants_event: event_as_participant, position: position)

      expect(position.events).to include(event)
      expect(position.events).to include(event_as_participant)
      expect(position.events).not_to include(other_event)
    end
  end

  describe ".finalize" do

    it "Should set 'to' to attribute with current timestamp" do
      now = Time.current
      allow(Time).to receive(:now).and_return(now)

      expect { position.finalize }.to change { position.to }.from(nil).to(now)
    end

    it "Should return self" do
      expect(position.finalize).to eq(position)
    end
  end

  describe "#holders" do
    let!(:user)             { create(:user, :user) }
    let!(:position)         { create(:position) }
    let!(:holder)           { position.holder }
    let!(:manage)           { create(:manage, holder: holder, user: user) }
    let!(:another_position) { create(:position) }

    it "Should return all holders managed by given user id" do
      expect(Position.holders(user.id)).to include(position)
      expect(Position.holders(user.id)).not_to include(another_position)
    end
  end

end
