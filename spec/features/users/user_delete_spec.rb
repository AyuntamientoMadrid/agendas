feature 'User delete' do

  scenario 'user can not delete own account', :js do
    user = FactoryGirl.create(:user, :admin)
    login_as(user, :scope => :user)
    visit users_path

    save_screenshot
    expect(page).to have_content I18n.t 'backend.users'
    page.click_link('',href: user_path(user))

    expect(page).to have_content I18n.t 'backend.unable_to_perform_operation'
  end

end
