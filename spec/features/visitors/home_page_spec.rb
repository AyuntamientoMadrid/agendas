feature 'Home page' do

  scenario 'visit the home page', :search do
    visit root_path
    expect(page).to have_content I18n.t 'main.title'
  end

  scenario 'visit holder agenda page', :search do
    @event = FactoryGirl.create(:event)
    Event.reindex
    Sunspot.commit
    visit root_path
    click_link @event.position.holder.full_name
    expect(page).to have_content @event.position.holder.full_name
  end

  feature 'search by date range' do
    before(:each) do
      @event1 = FactoryGirl.create(:event, scheduled: Time.now+1.days, title: 'less than XXthreeXX days')
      @event2 = FactoryGirl.create(:event, scheduled: Time.now+2.days, title: 'less than XXthreeXX days')
      @event3 = FactoryGirl.create(:event, scheduled: Time.now+3.days, title: 'exactly XXthreeXX days')
      @event4 = FactoryGirl.create(:event, scheduled: Time.now+4.days, title: 'more than XXthreeXX days (4)')
      @event5 = FactoryGirl.create(:event, scheduled: Time.now+5.days, title: 'more than XXthreeXX days (5)')
      Event.reindex
      Sunspot.commit
    end

    scenario 'in range', :search do
      visit root_path
      fill_in :from, with: Time.now
      fill_in :to, with: Time.now+3.days
      fill_in :keyword, with: 'XXthreeXX'
      click_button I18n.t('main.form.search')
      expect(page).to have_content "3 Resultados con la palabra XXthreeXX"
    end

    scenario 'in range', :search do
      visit root_path
      fill_in :from, with: Time.now+4.days
      fill_in :to, with: Time.now+5.days
      fill_in :keyword, with: 'XXthreeXX'
      click_button I18n.t('main.form.search')
      expect(page).to have_content "2 Resultados con la palabra XXthreeXX"
    end

    scenario 'out of range', :search do
      visit root_path
      fill_in :from, with: Time.now-2.days
      fill_in :to, with: Time.now-1.days
      fill_in :keyword, with: 'XXthreeXX'
      click_button I18n.t('main.form.search')
      expect(page).to have_content "0 Resultados con la palabra XXthreeXX"
    end

    scenario 'out of range', :search do
      visit root_path
      fill_in :from, with: Time.now+6.days
      fill_in :to, with: Time.now+7.days
      fill_in :keyword, with: 'XXthreeXX'
      click_button I18n.t('main.form.search')
      expect(page).to have_content "0 Resultados con la palabra XXthreeXX"
    end
  end

  scenario 'visit search by keyword result page', :search do
    @event = FactoryGirl.create(:event, title: 'New event from Capybara')
    visit root_path
    fill_in :keyword, with: 'Capybara'
    click_button I18n.t('main.form.search')
    expect(page).to have_content @event.title
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
