include Warden::Test::Helpers
Warden.test_mode!

feature 'User delete', :devise, :js do

  after(:each) do
    Warden.test_reset!
  end

  scenario 'user can not delete own account' do
    user = FactoryGirl.create(:user, :admin)
    login_as(user, :scope => :user)
    visit users_path
    expect(page).to have_content I18n.t 'backend.users'
    page.click_link('',href: user_path(user))
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content I18n.t 'backend.unable_to_perform_operation'
  end

end




