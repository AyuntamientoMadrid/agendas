feature 'Event page' do

  scenario 'visit the event detail page', :search do
    event = FactoryGirl.create(:event)
    Event.reindex
    Sunspot.commit
    visit root_path
    click_link event.title
    expect(page).to have_content event.title
  end

  scenario 'visit search by keyword and area result page', :search do
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
