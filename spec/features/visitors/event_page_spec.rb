feature 'Event page' do

  scenario 'visit the event detail page', :search do
    event = create(:event, published_at: Time.zone.yesterday)
    Event.reindex
    Sunspot.commit
    visit visitors_path

    click_link event.title

    expect(page).to have_content event.title
  end

  scenario 'visit search by keyword and area result page', :search do
    event = create(:event, title: 'New event from Capybara', published_at: Time.zone.yesterday)
    visit visitors_path

    fill_in :keyword, with: 'Capybara'
    select event.position.area.title, from: :area

    click_button I18n.t('main.form.search')
    expect(page).to have_content event.title
  end

  scenario 'visit non results search page' do
    event = create(:event, title: 'New not found event', published_at: Time.zone.yesterday)
    visit visitors_path

    fill_in :keyword, with: 'Capybara'
    click_button I18n.t('main.form.search')

    expect(page).not_to have_content event.title
    PublicActivity.set_controller(nil)
  end

  scenario 'show only published events', :search do
    event1 = create(:event, published_at: Time.zone.yesterday, title: 'event1')
    event2 = create(:event, published_at: Time.zone.today, title: 'event2')
    event3 = create(:event, published_at: Time.zone.tomorrow, title: 'event3')
    event4 = create(:event, published_at: Time.zone.yesterday, title: 'event4')

    event1.update(status: :requested)
    event2.update(status: :requested)
    event3.update(status: :requested)
    event4.update(status: :canceled)

    Event.reindex
    Sunspot.commit

    visit visitors_path

    expect(page).to have_content event1.title
    expect(page).to have_content event2.title
    expect(page).not_to have_content event3.title
    # expect(page).not_to have_content event4.title
  end

  scenario 'search lobby activity for visitors ', :search do
    event = create(:event, title: 'Test for check lobby_activity for visitors')
    event.lobby_activity = true
    event.event_agents << create(:event_agent)
    event.save!

    visit visitors_path
    check 'lobby_activity'
    click_button I18n.t('backend.search.button')

    expect(page).to have_content "Test for check lobby_activity for visitors"
  end

  describe 'show' do

    scenario 'Display event mandatory info' do
      event = create(:event, title: 'Lobby event')

      visit show_path(event)

      expect(page).to have_content event.title
      expect(page).to have_content event.location
      expect(page).to have_content event.description
      expect(page).to have_content event.position.holder.first_name
      expect(page).to have_content event.position.title.custom_titleize
      expect(page).to have_content event.position.area.title.custom_titleize
    end

    scenario 'Display event attachments public' do
      event = create(:event, title: 'Lobby event')
      attachment_public = create(:attachment, public: true, event: event)
      attachment_old = create(:attachment, event: event)
      attachment_private = create(:attachment, public: false, event: event)
      attachment_old.update_column(:public, nil)

      visit show_path(event)

      expect(page).to have_content attachment_public.title
      expect(page).to have_content attachment_public.description
      expect(page).to have_content attachment_old.title
      expect(page).to have_content attachment_old.description
      expect(page).not_to have_content attachment_private.title
      expect(page).not_to have_content attachment_private.description
    end

    scenario 'Display event lobby info' do
      event = create(:event, title: 'Lobby event')
      event.lobby_activity = true
      event.event_agents << create(:event_agent)
      event.event_represented_entities << create(:event_represented_entity)
      event.save!

      visit show_path(event)

      expect(page).to have_content event.organization.name
      expect(page).to have_content event.event_agents.first.name
      expect(page).to have_content event.event_represented_entities.first.name
    end

    scenario 'Display event lobby agents when organization have canceled_at' do
      event = create(:event, title: 'Lobby event')
      event.lobby_activity = true
      event.event_agents << create(:event_agent)
      event.save!
      event.organization.update(canceled_at: Date.current)

      visit show_path(event)

      expect(page).to have_content event.event_agents.first.name
    end

  end

end
