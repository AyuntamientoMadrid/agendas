feature 'Events Mailer' do

  describe "Cancel Event" do

    background do
      clear_emails
      @event = create(:event, title: 'New event from Capybara', user: create(:user))
      @event.cancel = 'true'
      @event.reasons = 'test'
      @event.save!
      open_email(@event.user.email)
    end

    scenario 'cancel event mail' do
      expect(current_email).to have_content I18n.t('mailers.cancel_event.text1', title: @event.title)
    end

  end

  describe "Decline Event" do

    background do
      clear_emails
      @event = create(:event, title: 'New event from Capybara',
        user: create(:user, :lobby))
      @event.lobby_contact_firstname = 'test_name'
      @event.lobby_contact_lastname = 'test_other_name'
      @event.lobby_contact_email = 'test_lobby_mail'
      @event.decline = 'true'
      @event.declined_reasons = 'test'
      @event.save!
      open_email(@event.lobby_contact_email)
    end

    scenario 'decline event mail' do
      expect(current_email).to have_content I18n.t('mailers.decline_event.text1', title: @event.title)
    end

  end
end
