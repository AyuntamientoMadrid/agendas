shared_examples "password editable" do |trait|
  let(:user) { create(:user, trait.to_sym) }

  before do
    login_as(user)
    visit admin_edit_password_path(user)
  end

  scenario "#{trait} can change their own account password", :js do
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t("admin.passwords.update.notice")
  end

  scenario "#{trait} Should show error when passwords are not equal" do
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '12345678'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t("admin.passwords.update.alert")
  end

  it "When a #{trait} changes his password he does not lose the session" do
    fill_in :user_password, with: 'new_password'
    fill_in :user_password_confirmation, with: 'new_password'
    click_button(I18n.t('backend.save'))

    expect(page).to have_content('Contraseña actualizada correctamente.')
    expect(page).to have_content('Cambiar contraseña')
  end

end