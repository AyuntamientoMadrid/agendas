
feature 'User delete' do

  scenario 'user can not delete own account' do
    user = FactoryGirl.create(:user, :admin)
    signin(user.email, "please123")
    visit users_path
    expect(page).to have_content I18n.t 'backend.users'
    page.click_link('',href: user_path(user))
    expect(page).to have_content I18n.t 'backend.unable_to_perform_operation'
  end

end
