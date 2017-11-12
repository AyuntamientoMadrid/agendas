feature 'Home page' do

  scenario 'Should show page title', :search do
    visit root_path

    expect(page).to have_content I18n.t 'main.title'
  end

  scenario 'Should show events list', :search do
    event = create(:event)
    Event.reindex
    Sunspot.commit
    visit root_path

    within "#event_#{event.id}" do
      expect(page).to have_link event.title
      expect(page).to have_link event.position.holder.full_name
      expect(page).to have_content event.position.area.title
      expect(page).to have_content I18n.l(event.scheduled, format: :complete)
    end
  end

  feature 'Search by date range' do

    let!(:event1) { create(:event, scheduled: Time.now + 1.days, title: 'Boring debating session') }
    let!(:event2) { create(:event, scheduled: Time.now + 2.days, title: 'Awesome meeting') }

    before do
      Event.reindex
      Sunspot.commit
    end

    scenario 'Should show only in range scheduled events', :search do
      visit root_path

      fill_in :from, with: Time.now + 2.days
      fill_in :to, with: Time.now + 2.days
      click_button I18n.t('main.form.search')

      expect(page).not_to have_content event1.title
      expect(page).to have_content event2.title
    end

    scenario 'And keyword should show only in range scheduled events with given keyword', :search do
      event3 = create(:event, scheduled: Time.now + 2.days, title: 'Awful meeting')
      visit root_path

      fill_in :from, with: Time.now + 2.days
      fill_in :to, with: Time.now + 2.days
      fill_in :keyword, with: 'Awesome'
      click_button I18n.t('main.form.search')

      expect(page).to have_content event2.title
      expect(page).not_to have_content event3.title
    end

    scenario 'Should not show results when selected dates are in the past and there is no events defined', :search do
      visit root_path

      fill_in :from, with: Time.now - 2.days
      fill_in :to, with: Time.now - 1.days
      click_button I18n.t('main.form.search')

      expect(page).not_to have_selector ".event"
    end

    scenario 'Should not show results when selected dates are in the future and there events defined', :search do
      visit root_path

      fill_in :from, with: Time.now + 6.days
      fill_in :to, with: Time.now + 7.days
      fill_in :keyword, with: 'XXthreeXX'
      click_button I18n.t('main.form.search')

      expect(page).to have_content "0 Resultados con la palabra XXthreeXX"
    end
  end

  scenario 'Search by keyword should show only matching events', :search do
    event1 = create(:event, title: 'New event from Capybara')
    event2 = create(:event, title: 'Another amazing title')
    visit root_path

    fill_in :keyword, with: 'amazing'
    click_button I18n.t('main.form.search')

    expect(page).not_to have_content event1.title
    expect(page).to have_content event2.title
  end

  scenario 'Search by area should show only matching events', :search do
    event1 = create(:event, title: 'New event from Capybara')
    event2 = create(:event, title: 'Another amazing title')
    visit root_path

    select event1.position.area.title, from: :area
    click_button I18n.t('main.form.search')

    expect(page).to have_content event1.title
    expect(page).not_to have_content event2.title
  end

  scenario 'Should show empty results notice when no matching records found with given keywords' do
    create(:event, title: 'New not found event')
    visit root_path

    fill_in :keyword, with: 'Capybara'
    click_button I18n.t('main.form.search')

    expect(page).to have_content "0 Resultados con la palabra Capybara"
  end

end
