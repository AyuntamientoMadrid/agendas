feature 'Events' do

  before do
    @user = FactoryGirl.create(:user)
    @position = FactoryGirl.create(:position)
    @user.manages.create(holder_id: @position.holder_id)
    signin(@user.email, @user.password)
  end

  scenario 'visit the events index page' do
    visit events_path
    expect(page).to have_content I18n.t 'backend.events'
  end

  scenario 'visit create event form' do
    visit new_event_path
    expect(page).to have_selector('#new_event')
    expect(page).not_to have_selector('#edit_event')
  end

  scenario 'visit show event page' do
    event = FactoryGirl.create(:event, title: 'New event from Capybara', user: @user)
    visit events_path
    click_link event.title
    expect(page).to have_content event.title
  end

  scenario 'edit event and modify title' do
    event = FactoryGirl.create(:event, title: 'Test event', user: @user)
    visit edit_event_path(event)
    #expect(page).to have_selector('#edit_event')
    fill_in :event_title, with: 'New event modified from Capybara'
    click_button I18n.t 'backend.save'
    expect(page).to have_content 'New event modified from Capybara'
  end

  scenario 'visit search by keyword and area result page' do
    @event = FactoryGirl.create(:event, title: 'New event from Capybara')
    visit root_path
    fill_in :keyword, with: 'Capybara'
    select @event.position.area.title, from: :area
    click_button I18n.t('main.form.search')
    expect(page).to have_content @event.title
  end

  scenario 'visit non results search page' do
    @event = FactoryGirl.create(:event, title: 'New not found event')
    visit root_path
    fill_in :keyword, with: 'Capybara'
    click_button I18n.t('main.form.search')
    expect(page).not_to have_content @event.title
  end

end
