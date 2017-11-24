shared_examples "password editable" do |trait|
  scenario "#{trait} user can change their own account password" do
    user = create(:user, trait.to_sym)
    login_as user
    visit edit_password_path

    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t("admin.passwords.update.notice")
  end

  scenario "Should show error when passwords are not equal" do
    user = create(:user, trait.to_sym)
    login_as user
    visit edit_password_path

    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '12345678'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t("admin.passwords.update.alert")
  end
end

feature 'Passwords' do

  it_behaves_like "password editable", "user"
  it_behaves_like "password editable", "admin"
  it_behaves_like "password editable", "lobby"

  scenario "Edit Should not be available for anonymous users" do
    visit edit_password_path

    expect(page).to have_content "Necesitas iniciar sesión o registrarte para continuar. "
  end

end
