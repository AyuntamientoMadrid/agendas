describe EventMailer, type: :mailer do

  let!(:user)   { create(:user) }
  let!(:event)  { create(:event, title: 'New event from Capybara', user: user) }
  let!(:manage) { create(:manage, user: user, holder: event.position.holder) }

  describe "cancel_by_lobby" do

    before do
      event.update(status: 'accepted')
      event.cancel = 'true'
      event.canceled_reasons = 'test'
      event.lobby_contact_email = 'test@test'
      event.lobby_activity = true
      event.description = "Description test"
      event.save!
    end
    let(:mail) { EventMailer.cancel_by_lobby(event) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to event holder manager user (manager)" do
      manages_emails = event.position.holder.users.collect(&:email)

      expect(mail.to).to eq(manages_emails)
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including event id" do
      expect(mail.subject).to eq(I18n.t('mailers.cancel_event.subject', event_reference: event.id))
    end

    it 'should contain cancelation event information' do
      expect(mail.body).to have_content event.description
      expect(mail.body).to have_content event.canceled_reasons
      expect(mail.body).to have_content event.position.holder.users.collect(&:email).join(",")
      lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
      expect(mail.body).to have_content lobby_name
      expect(mail.body).to have_content event.user.full_name
      expect(mail.body).to have_content event.title
      expect(mail.body).to have_content event.location
      scheduled_date = I18n.l(event.scheduled, format: :long)
      expect(mail.body).to have_content scheduled_date
      expect(mail.body).to have_content event.description
      expect(mail.subject).to have_content I18n.t('mailers.cancel_event.subject', event_reference: event.id)
    end

  end

  describe "decline" do

    before do
      event.lobby_contact_firstname = 'test_name'
      event.lobby_contact_lastname = 'test_other_name'
      event.lobby_contact_email = 'lobby@email.com'
      event.decline = 'true'
      event.declined_reasons = 'test'
      event.lobby_activity = true
      event.save!
    end
    let(:mail) { EventMailer.decline(event) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to event holder manager user (manager)" do
      expect(mail.to).to include('lobby@email.com')
      event.position.holder.users.collect(&:email).each do |email|
        expect(mail.to).to include(email)
      end
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including event id" do
      expect(mail.subject).to eq(I18n.t('mailers.decline_event.subject', event_reference: event.id))
    end

    it 'shoul contain declination event information' do
      expect(mail.body).to have_content event.declined_reasons
      expect(mail.body).to have_content event.title
      expect(mail.body).to have_content event.description
    end

  end

  describe "accept" do

    before do
      event.lobby_contact_firstname = 'test_name'
      event.lobby_contact_lastname = 'test_other_name'
      event.lobby_contact_email = 'lobby@email.com'
      event.accept = 'true'
      event.lobby_activity = true
      event.save!
    end
    let(:mail) { EventMailer.accept(event) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to lobby_contact_email if present" do
      expect(mail.to).to include('lobby@email.com')
      expect(mail.to).not_to include(event.organization.user.email)
    end

    it "should be send to lobby_contact_email if present" do
      event.lobby_contact_email = nil
      mail = EventMailer.accept(event)

      expect(mail.to).to include(event.organization.user.email)
      expect(mail.to).not_to include('lobby@email.com')
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including event id" do
      expect(mail.subject).to eq(I18n.t('mailers.accept_event.subject', event_reference: event.id))
    end

    it 'should contain acceptation event information' do
      expect(mail.body).to have_content event.title
      expect(mail.body).to have_content event.description
      expect(mail.body).to have_content event.id
      expect(mail.body).to have_content event.location
    end

  end

  describe "cancel_by_holder" do

    before do
      event.update(status: 'accepted')
      event.cancel = 'true'
      event.canceled_reasons = 'test'
      event.lobby_contact_email = 'lobby@email.com'
      event.lobby_activity = true
      event.save!
      manages_emails = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    end
    let(:mail) { EventMailer.cancel_by_holder(event) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to lobby_contact_email if present" do
      expect(mail.to).to include('lobby@email.com')
      expect(mail.to).not_to include(event.organization.user.email)
    end

    it "should be send to lobby_contact_email if present" do
      event.lobby_contact_email = nil
      mail = EventMailer.accept(event)

      expect(mail.to).to include(event.organization.user.email)
      expect(mail.to).not_to include('lobby@email.com')
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including event id" do
      expect(mail.subject).to eq(I18n.t('mailers.cancel_event_by_holder.subject', event_reference: event.id))
    end

    it 'should contain cancel event by holder information' do
      expect(mail.body).to have_content event.canceled_reasons
      expect(mail.body).to have_content event.title
      expect(mail.body).to have_content event.location
      expect(mail.body).to have_content event.description
      expect(mail.body).to have_content I18n.l(event.scheduled, format: :long)
    end

  end

  describe "create" do

    before do
      event.lobby_contact_email = 'lobby@email.com'
      event.save!
    end

    let(:mail) { EventMailer.create(event) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to lobby_contact_email if present" do
      expect(mail.to).to include('lobby@email.com')
      expect(mail.to).not_to include(event.organization.user.email)
    end

    it "should be send to lobby_contact_email if present" do
      event.lobby_contact_email = nil
      mail = EventMailer.accept(event)

      expect(mail.to).to include(event.organization.user.email)
      expect(mail.to).not_to include('lobby@email.com')
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including event id" do
      expect(mail.subject).to eq(I18n.t('mailers.create_event.subject', event_reference: event.id))
    end

    it "should contains event request information" do
      expect(mail.body).to have_content event.title
      expect(mail.body).to have_content event.description
      expect(mail.body).to have_content I18n.l(event.scheduled, format: :long)
      expect(mail.body).to have_content event.organization_name
    end

  end
end
