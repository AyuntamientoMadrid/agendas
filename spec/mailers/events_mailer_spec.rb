feature 'Events Mailer' do

  describe "Cancel Event" do
    background do
      user = create(:user, :user)
      login_as user
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: user)
      create(:manage, user: user, holder: @event.position.holder)
      @event.update(status: 'accepted')
      @event.cancel = 'true'
      @event.canceled_reasons = 'test'
      @event.lobby_contact_email = 'test@test'
      @event.lobby_activity = true
      @event.description = "Description test"
      @event.save!
      manages_emails = @event.position.holder.users.collect(&:email).join(",")

      EventMailer.cancel_by_lobby(@event).deliver_now

      open_email(manages_emails)
    end

    scenario 'cancel event mail ' do
      expect(current_email).to have_content I18n.t('mailers.cancel_event.text1', event_reference: @event.id)
      expect(current_email).to have_content I18n.t('mailers.cancel_event.text2')
      expect(current_email).to have_content @event.description
      expect(current_email).to have_content @event.canceled_reasons

    end

  end

  describe "Decline Event" do

    background do
      user = create(:user, :user)
      login_as user
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: user)
      @event.lobby_contact_firstname = 'test_name'
      @event.lobby_contact_lastname = 'test_other_name'
      @event.lobby_contact_email = 'test_lobby_mail'
      @event.decline = 'true'
      @event.declined_reasons = 'test'
      @event.lobby_activity = true
      @event.save!

      EventMailer.decline(@event).deliver_now

      open_email(@event.lobby_contact_email)
    end

    scenario 'decline event mail' do
      expect(current_email).to have_content I18n.t('mailers.decline_event.text1', event_reference: @event.id)
      expect(current_email).to have_content @event.title
      expect(current_email).to have_content @event.description
    end

  end

  describe "Accept Event" do

    background do
      user = create(:user, :user)
      login_as user
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: user)
      @event.lobby_contact_firstname = 'test_name'
      @event.lobby_contact_lastname = 'test_other_name'
      @event.lobby_contact_email = 'test_lobby_mail'
      @event.accept = 'true'
      @event.lobby_activity = true
      @event.save!

      EventMailer.accept(@event).deliver_now

      open_email(@event.lobby_contact_email)
    end

    scenario 'accept event mail' do
      expect(current_email).to have_content I18n.t('mailers.accept_event.head1', event_reference: @event.id)
      expect(current_email).to have_content I18n.t('mailers.accept_event.text1', event_reference: @event.id)
      expect(current_email).to have_content @event.location
      expect(current_email).to have_content @event.description
    end

  end

  describe "Cancel Event" do
    background do
      user = create(:user, :user)
      login_as user
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: user)
      create(:manage, user: user, holder: @event.position.holder)
      @event.update(status: 'accepted')
      @event.cancel = 'true'
      @event.canceled_reasons = 'test'
      @event.lobby_contact_email = 'test@test'
      @event.lobby_activity = true
      @event.save!
      manages_emails = @event.position.holder.users.collect(&:email).join(",")

      EventMailer.cancel_by_lobby(@event).deliver_now

      open_email(manages_emails)
    end

    scenario 'cancel event mail lobby' do
      expect(current_email).to have_content I18n.t('mailers.cancel_event.text1', event_reference: @event.id)
      expect(current_email).to have_content I18n.t('mailers.cancel_event.head1', event_reference: @event.id)
      expect(current_email).to have_content @event.location
      expect(current_email).to have_content @event.canceled_reasons
    end

  end

  describe "Create Event" do
    background do
      user = create(:user, :lobby)
      login_as user
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: user,
                              lobby_contact_email: 'test@test', lobby_activity: true, status: "requested")
      create(:manage, user: user, holder: @event.position.holder)
      manages_emails = @event.position.holder.users.collect(&:email).join(",")

      EventMailer.create(@event).deliver_now

      open_email(manages_emails)
    end

    scenario 'create event mail' do
      expect(current_email).to have_content I18n.t('mailers.create_event.text1', event_reference: @event.id)
      expect(current_email).to have_content I18n.t('mailers.create_event.text4')
      expect(current_email).to have_content @event.title
      expect(current_email).to have_content @event.organization_name
    end

  end
end
