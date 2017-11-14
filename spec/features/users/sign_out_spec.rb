feature 'Sign out', :devise do

  scenario 'user signs out successfully' do

    user = create(:user)
    signin(user.email, user.password)
    expect(page).to have_content I18n.t 'devise.sessions.signed_in'

    visit events_path

    expect(page).to have_content I18n.t('backend.logout')
    click_link I18n.t("backend.logout") + " - (#{user.full_name})"

    expect(page).to have_content I18n.t 'devise.sessions.signed_out'
  end

end


