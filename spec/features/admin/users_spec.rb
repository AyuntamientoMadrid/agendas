feature 'Users', :devise do

  describe 'Index' do

    scenario 'user sees own email address' do
      user = create(:user, :admin)
      login_as user

      visit admin_users_path

      expect(page).to have_content user.email
    end

    scenario "Cannot be accessed by lobby user" do
      lobby = create(:user, :lobby)
      login_as lobby

      visit admin_users_path

      expect(page).to have_content I18n.t 'backend.access_denied'
    end

    scenario "Cannot be accessed by manager user" do
      lobby = create(:user, :user)
      login_as lobby

      visit admin_users_path

      expect(page).to have_content I18n.t 'backend.access_denied'
    end

    describe 'CSV export link' do

      let!(:admin)    { create(:user, :admin) }
      let!(:manager)  { create(:user) }
      let!(:manage)   { create(:manage, user: manager) }
      let!(:lobby)    { create(:user, :lobby) }

      before { login_as admin }

      scenario 'Should download a CSV file UTF-8 encoded' do
        visit admin_users_path

        click_on "Exportar"

        header = page.response_headers['Content-Type']
        expect(header).to match 'text/csv; charset=utf-8'
      end

      scenario 'Should download CSV with headers' do
        visit admin_users_path

        click_link "Exportar"

        headers = [I18n.t('backend.role'),
                   I18n.t('backend.users'),
                   I18n.t('backend.user_url'),
                   I18n.t('backend.holder'),
                   I18n.t('backend.agenda_url')]
        headers.each do |column_header|
          expect(page).to have_content column_header
        end
      end

      scenario 'Should contain only holders information' do
        visit admin_users_path

        click_link "Exportar"

        expect(page).to have_content admin_user_url(manager)
        expect(page).to have_content manager.full_name
        expect(page).to have_content manager.holders.first.full_name
        expect(page).to have_content agenda_url(manager.holders.first, manager.holders.first.full_name.parameterize)
      end

    end

  end

  describe 'Show' do

    scenario 'user cannot see own profile' do
      user = create(:user)
      login_as user
      visit admin_user_path(user)

      expect(page).to have_content I18n.t 'backend.access_denied'
    end

    scenario "user cannot see another user's profile" do
      me = create(:user)
      other = create(:user, email: 'other@example.com')
      login_as me
      Capybara.current_session.driver.header 'Referer', root_path
      visit admin_user_path(other)
      expect(page).to have_content I18n.t 'backend.access_denied'
    end

  end

  describe 'Destroy' do

    scenario 'User can not delete own account' do
      user = create(:user, :admin)
      login_as user
      visit admin_users_path

      expect(page).to have_content I18n.t 'backend.users'
      page.click_link('', href: admin_user_path(user))

      expect(page).to have_content I18n.t 'backend.unable_to_perform_operation'
    end

  end

  describe 'Edit' do

    scenario 'admin can change own email address' do
      user = create(:user, :admin)
      login_as user
      visit edit_admin_user_path(user)

      fill_in :user_email, :with => 'adminemail@example.com'
      click_button I18n.t 'backend.save'

      expect(page).to have_content I18n.t 'backend.successfully_updated_record'
    end

    scenario 'admin can change other user email address' do
      admin = create(:user, :admin, email: 'adminemail@example.com')
      login_as admin
      user = create(:user)
      visit edit_admin_user_path(user)

      fill_in :user_email, :with => 'useremail@example.com'
      click_button I18n.t 'backend.save'

      expect(page).to have_content I18n.t 'backend.successfully_updated_record'
    end

    scenario "user cannot edit another user's profile", :me do
      me = create(:user)
      other = create(:user, email: 'other@example.com')
      login_as me

      visit edit_admin_user_path(other)

      expect(page).to have_content I18n.t 'backend.access_denied'
    end

  end

  describe "update" do
    let(:admin) { create(:user, :admin) }
    let(:user) { create(:user, :user) }

    before { login_as admin }

    it "Admin user can update an user's information without updating the password" do
      visit edit_admin_user_path(user)

      fill_in :user_email, with: 'example@mail.com'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content(I18n.t('backend.successfully_updated_record'))
    end

    it "Admin user can't reset an user's password if the params don't match" do
      visit edit_admin_user_path(user)

      fill_in :user_password, with: 'new_password'
      fill_in :user_password_confirmation, with: 'no_match'
      click_button(I18n.t('backend.save'))

      expect(page).to have_content('Confirmación de la contraseña no coincide')
    end
  end

end
