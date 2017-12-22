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

    expect(event).to be_valid
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
      expect(Event.title("event").count).to eq(2)
    end

    it "Should return events matching exact title" do
      expect(Event.title("This event is awesome!")).to eq([event2])
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
    let!(:event) { create(:event, position: holder.current_position, title: "Some amazing title",
                                  lobby_activity: false, status: "accepted") }

    it "Should return events by given holder name" do
      params = {}
      params[:person] = "John"
      expect(Event.searches(params)).to eq([event])
    end

    it "Should return events by given title name" do
      params = {}
      params[:person] = "Doe"
      expect(Event.searches(params)).to eq([event])
    end

    it "Should return events by given status" do
      params = {}
      params[:title] = "Some amazing title"
      params[:status] = 1 # accepted
      expect(Event.searches(params)).to eq([event])
    end

    it "Should return events by different status" do
      params = {}
      params[:title] = "Some amazing title"
      params[:status] = 2
      expect(Event.searches(params)).not_to eq([event])
    end

  end

  describe "lobby organizations' events" do
    let!(:organization_user) { create(:user, :lobby) }

    it "lobby user should create event with status on_request" do
      event = create(:event, title: 'Event on request', user: organization_user)
      event.save
      expect(event.status).to eq('requested')
    end
  end

  describe "regular organizations' events" do
    let!(:organization_user) { create(:user, :user) }

    it "regular user should create event with status accepted" do
      event = create(:event, title: 'Event on request', user: organization_user)
      event.save

      expect(event.status).to eq('accepted')
    end
  end

  describe "regular organizations' events" do
    let!(:organization_user) { create(:user, :admin) }

    it "admin user should create event with status accepted" do
      event = create(:event, title: 'Event on request', user: organization_user)
      event.save

      expect(event.status).to eq('accepted')
    end
  end

  describe "only can be canceled accepted events" do
    let!(:organization_user) { create(:user, :user) }

    it "accepted events can be canceled" do
      event = create(:event, title: 'Event on request', user: organization_user)

      event.canceled_at = Time.zone.today
      event.canceled_reasons = 'test'

      expect(event).to be_valid
    end

    it "accepted events can be canceled" do
      event = create(:event, title: 'Event on request', user: organization_user)
      event.status = 'done'
      event.canceled_at = Time.zone.today
      event.canceled_reasons = 'test'

      expect(event).not_to be_valid
    end

  end

end
