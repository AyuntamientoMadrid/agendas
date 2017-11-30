require 'rails_helper'

describe Event do

  let(:event) { build(:event) }

  it "Should be valid" do
    expect(event).to be_valid
  end

  it "Should be invalid if no title defined" do
    event.title = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if no position defined" do
    event.position = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if event not scheduled" do
    event.scheduled = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if event not lobby_activity" do
    event.lobby_activity = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if event not published_at" do
    event.published_at = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if event not location" do
    event.location = nil

    expect(event).not_to be_valid
  end

  it "Should be invalid if participant are not unique" do
    event = create(:event)
    participant = create(:participant)
    event.participants << participant
    event.participants << participant

    expect(event).not_to be_valid
  end

  it "Should be invalid when position event assigned as participant too" do
    event = create(:event)
    event.participants << create(:participant,
                                 participants_event: event)
    event.participants << create(:participant,
                                 participants_event: event,
                                 position: event.position)

    expect(event).not_to be_valid
  end

  describe ".by_title" do
    let!(:event1) { create(:event, title: "This event rocks!") }
    let!(:event2) { create(:event, title: "This event is awesome!") }

    it "Should return events matching given string" do
      expect(Event.by_title("event").count).to eq(2)
    end

    it "Should return events matching exact title" do
      expect(Event.by_title("This event is awesome!")).to eq([event2])
    end
  end

  describe ".by_holders" do
    let!(:event) { create(:event) }
    let!(:event2) { create(:event) }

    it "Should return all events from given holders ids" do
      expect(Event.by_holders([event.position.holder.id])).to eq([event])
    end
  end

  describe ".by_participant_holders" do
    let!(:event)       { create(:event) }
    let!(:event2)      { create(:event) }
    let!(:participant) { create(:participant, participants_event: event) }

    it "Should return all events where given holders ids acts as participants" do
      expect(Event.by_participant_holders([participant.position.holder.id])).to eq([event])
    end
  end

  describe ".by_holder_name" do
    let!(:holder) { create(:holder, :with_position, first_name: "John", last_name: "Doe") }
    let!(:event)  { create(:event, position: holder.current_position) }

    it "Should return all events where holders contains given name" do
      expect(Event.by_holder_name("John Doe")).to eq([event])
    end
  end

  describe ".managed_by" do

    let!(:user)   { create(:user, :user) }
    let!(:manage) { create(:manage, user: user) }
    let!(:position) { create(:position, holder: manage.holder) }
    let!(:event) { create(:event, position: position) }
    let!(:event_as_participant) { create(:event) }
    let!(:participant) { create(:participant, position: position, participants_event: event_as_participant) }

    it "Should return all events where given user holders acts as holders or participants" do
      expect(Event.managed_by(user)).to eq([event, event_as_participant])
    end

  end

  describe ".ability_events" do

    it "Should return all events ids where given user holders are present as holders" do
      event = create(:event)
      manage = create(:manage, holder: event.position.holder)

      expect(Event.ability_events(manage.user)).to eq([event.id])
    end

    it "Should return all events ids where given user holders are present as participants" do
      event = create(:event)
      participant = create(:participant, participants_event: event)
      manage = create(:manage, holder: participant.position.holder)

      expect(Event.ability_events(manage.user)).to eq([event.id])
    end

  end

  describe ".ability_titular_events" do

    it "Should return all events ids where given user holders are present as holders" do
      event = create(:event)
      manage = create(:manage, holder: event.position.holder)

      expect(Event.ability_titular_events(manage.user)).to eq([event.id])
    end

  end

  describe ".ability_participants_events" do
    it "Should return all events ids where given user holders are present as participants" do
      event = create(:event)
      participant = create(:participant, participants_event: event)
      manage = create(:manage, holder: participant.position.holder)

      expect(Event.ability_participants_events(manage.user)).to eq([event.id])
    end

  end

  describe ".searches" do
    let!(:holder) { create(:holder, :with_position, first_name: "John", last_name: "Doe") }
    let!(:event) { create(:event, position: holder.current_position, title: "Some amazing title" , lobby_activity: false) }

    it "Should return events by given holder name" do
      expect(Event.searches("John", "", false)).to eq([event])
    end

    it "Should return events by given title name" do
      expect(Event.searches("", "amazing", false)).to eq([event])
    end

  end

  describe "organizations' events" do
    let!(:organization_user) { create(:user, :lobby) }

    it "should create event with status on_request" do
      event = create(:event, title: 'Event on request', user: organization_user)
      event.save

      expect(event.status).to eq('requested')
    end

  end

end
