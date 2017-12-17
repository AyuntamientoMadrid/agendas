shared_examples "password editable" do |trait|
  background do
    user = create(:user, trait.to_sym)
    login_as(user)
    visit edit_password_path
  end

  scenario "#{trait} user can change their own account password" do
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_button I18n.t 'backend.save'

    expect(page).to have_content I18n.t("admin.passwords.update.notice")
  end

  scenario "Should show error when passwords are not equal" do
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

  context 'Admin' do
    background do
      admin = create(:user, :admin)
      user  = create(:user, password: 'password')
      login_as(admin, scope: :user)
      visit edit_user_path(user)
    end

    it "can reset any user's password" do
      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'new_password'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content(I18n.t('backend.successfully_updated_record'))
    end

    it "can update an user's information without updating the password" do
      fill_in :user_email, with: 'example@mail.com'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content(I18n.t('backend.successfully_updated_record'))
    end

    it "can't reset an user's password if the params don't match" do
      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'no_match'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content('Confirmación de la contraseña no coincide')
    end

    it "correct user role when can't reset an user's password" do
      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'no_match'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content('1 error impidió guardar este gestor de agenda')
    end
  end

  context 'Lobby' do
    background do
      @lobby = create(:user, :lobby)
      login_as(@lobby)
      visit edit_password_path(@lobby)
    end

    it "correct user role when can't reset an user's password" do
      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'no_match'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content('1 error impidió guardar este Lobby')
    end

    it "When a user changes his password he does not lose the session" do
      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'new_password'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content('Contraseña actualizada correctamente.')
      expect(page).to have_content('Cambiar contraseña')
    end
  end

end
