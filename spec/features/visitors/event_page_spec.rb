feature 'Event page' do

  scenario 'visit the event detail page', :search do
    event = create(:event, published_at: Time.zone.tomorrow)
    Event.reindex
    Sunspot.commit
    visit root_path

    click_link event.title

    expect(page).to have_content event.title
  end

  scenario 'visit search by keyword and area result page', :search do
    event = create(:event, title: 'New event from Capybara', published_at: Time.zone.tomorrow)
    visit root_path

    fill_in :keyword, with: 'Capybara'
    select event.position.area.title, from: :area

    click_button I18n.t('main.form.search')
    expect(page).to have_content event.title
  end

  scenario 'visit non results search page' do
    event = create(:event, title: 'New not found event', published_at: Time.zone.tomorrow)
    visit root_path

    fill_in :keyword, with: 'Capybara'
    click_button I18n.t('main.form.search')

    expect(page).not_to have_content event.title
    PublicActivity.set_controller(nil)
  end

  scenario 'show only published events', :search do
    event1 = create(:event, published_at: Time.zone.yesterday, title: 'event1')
    event2 = create(:event, published_at: Time.zone.today, title: 'event2')
    event3 = create(:event, published_at: Time.zone.tomorrow, title: 'event3')
    Event.reindex
    Sunspot.commit

    visit root_path

    expect(page).not_to have_content event1.title
    expect(page).to have_content event2.title
    expect(page).to have_content event3.title
  end

  scenario 'search lobby activity for visitors ', :search do
    create(:event, title: 'Test for check lobby_activity for visitors', lobby_activity: true)
    
    check 'lobby_activity'
    click_button I18n.t('backend.search.button')

    expect(page).to have_content "Test for check lobby_activity for visitors"
  end


end
