feature 'Sessions', :devise do

  describe 'Create' do

    scenario 'user cannot sign in if not registered' do
      signin('test@example.com', 'please123')

      expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'Email'
    end

    scenario 'user can sign in with valid credentials' do
      user = create(:user)
      signin(user.email, user.password)

      expect(page).to have_content I18n.t 'devise.sessions.signed_in'
    end

    scenario 'user cannot sign in with wrong email' do
      user = create(:user)
      signin('invalid@email.com', user.password)

      expect(page).to have_content I18n.t 'devise.failure.not_found_in_database', authentication_keys: 'Email'
    end

    scenario 'user cannot sign in with wrong password' do
      user = create(:user)
      signin(user.email, 'invalidpass')

      expect(page).to have_content I18n.t 'devise.failure.invalid', authentication_keys: 'Email'
    end

    scenario 'render link to register sede.electonica' do
      visit admin_path

      expect(page).to have_content "¿No tienes una cuenta?"
      expect(page).to have_content "¿Olvidaste la contraseña?"
      expect(page).to have_link("Regístrate", href: "https://sede.madrid.es")
    end

    scenario 'should not allow soft deleted user' do
      user = create(:user, deleted_at: DateTime.current)
      signin(user.email, user.password)

      expect(page).to have_content "Tu cuenta está bloqueada"
    end

  end

  describe 'Destroy' do

    scenario 'Should destroy user session successfully' do
      user = create(:user)
      login_as user

      visit events_path

      expect(page).to have_content I18n.t('backend.logout')
      click_link I18n.t("backend.logout") + " - (#{user.full_name})"
      expect(page).to have_content I18n.t 'devise.sessions.signed_out'
    end
  end

end
