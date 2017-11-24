feature 'User edit', :devise do

  scenario 'admin can change own email address' do
    user = create(:user, :admin)
    login_as(user, :scope => :user)
    visit edit_user_path(user)

    fill_in :user_email, :with => 'adminemail@example.com'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t 'backend.successfully_updated_record'
  end

  scenario 'admin can change other user email address' do
    admin = create(:user, :admin, email: 'adminemail@example.com')
    login_as(admin, :scope => :user)
    user = create(:user)
    visit edit_user_path(user)

    fill_in :user_email, :with => 'useremail@example.com'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t 'backend.successfully_updated_record'
  end

  scenario "user cannot edit another user's profile", :me do
    me = create(:user)
    other = create(:user, email: 'other@example.com')
    login_as(me, :scope => :user)

    visit edit_user_path(other)

    expect(page).to have_content I18n.t 'backend.access_denied'
  end

end
