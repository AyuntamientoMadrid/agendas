feature 'Events' do

  describe 'user manager' do

    background do
      user_manager = create(:user, :user)
      position = create(:position)
      user_manager.manages.create(holder_id: position.holder_id)
      signin(user_manager.email, user_manager.password)
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
  end

  describe 'user admin' do
    background do
      user_admin = create(:user, :admin)
      position = create(:position)
      user_admin.manages.create(holder_id: position.holder_id)
      signin(user_admin.email, user_admin.password)
    end

    scenario 'visit show event page' do
      event = create(:event, title: 'New event from Capybara')
      visit events_path

      click_link event.title

      expect(page).to have_content event.title
    end

    scenario 'edit event and modify title' do
      event = create(:event, title: 'Test event')
      visit edit_event_path(event)

      fill_in :event_title, with: 'New event modified from Capybara'
      click_button I18n.t 'backend.save'

      expect(page).to have_content 'New event modified from Capybara'
    end

    scenario 'visit search by title' do
      event = create(:event, title: 'New event from Capybara')
      visit events_path

      fill_in :search_title, with: 'Capybara'
      click_button I18n.t('backend.search.button')

      expect(page).to have_content event.title
    end

    scenario 'visit search by person' do
      event = create(:event, title: 'New event from Capybara')
      name = event.position.holder.first_name
      visit events_path

      fill_in :search_person, with: name
      click_button I18n.t('backend.search.button')

      expect(page).to have_content event.title
    end

    scenario 'visit non results search page' do
      create(:event, title: 'New not found event')
      visit events_path

      fill_in :search_title, with: 'Search keywords'
      click_button I18n.t('backend.search.button')

      expect(page).to have_content "No se han encontrado eventos"
    end

  end

  describe 'Organization user' do
    background do
      organization_user = create(:user, :lobby)
      @position = create(:position)
      organization_user.manages.create(holder_id: @position.holder_id)
      signin(organization_user.email, organization_user.password)
    end

    scenario 'visit index event page' do
      event = create(:event, title: 'New event for lobbies', position: @position)
      visit events_path

      expect(page).to have_content event.title
    end

    scenario 'create new event' do
      event = create(:event, title: 'Event not for lobbies')
      visit events_path

      click_link I18n.t('backend.new_event')

      expect(page).to have_content I18n.t('backend.new_event')

      fill_in :event_title, with: 'New event for a lobby'
      fill_in :event_scheduled, with: '02/11/2017 06:30'

      click_button I18n.t('backend.save')

      expect(page).to have_content 'New event for a lobby'
      expect(page).to_not have_content event.title
    end

  end
end
