feature "Application" do

  scenario "Try to access privileged options after closing session", :js do

    ActionController::Base.allow_forgery_protection = true
    position = create(:position)
    user = FactoryGirl.create(:user, :admin)

    login_as user

    event = create(:event, user: user, title: 'Test event', position: position)
    visit edit_event_path(event)

    new_window = open_new_window
    within_window new_window do
      visit root_path
      click_link I18n.t('backend.logout')
    end

    click_button I18n.t('backend.save')

    expect(page).to have_content I18n.t 'devise.sessions.new.forgot_your_password'
    expect(page).not_to have_content 'ActionController::InvalidAuthenticityToken'
  end
end
