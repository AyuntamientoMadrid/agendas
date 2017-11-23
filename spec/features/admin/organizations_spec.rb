feature 'Organization' do

  describe 'User admin' do
    background do
      user_admin = create(:user, :admin)
      signin(user_admin.email, user_admin.password)
    end

    describe "Index" do
      background do
        3.times { create(:organization) }
      end

      scenario 'visit admin page and organization button render organization index' do
        visit admin_path

        click_link "Organizaciones"

        expect(page).to have_content "Nueva organización"
        expect(page).to have_content "#{I18n.t 'backend.companies'} (3)"
      end

    end
  end
end
