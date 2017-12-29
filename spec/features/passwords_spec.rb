require 'spec_helper'

describe "Passwords" do

  describe "New" do

    let!(:user) { create(:user) }

    it "Should send account recovery email when email exists" do
      visit new_user_password_path

      fill_in "user[email]", with: user.email
      find('[name=commit]').click

      expect(page).to have_content 'Recibirás un correo electrónico ' \
                                   'con instrucciones sobre cómo '    \
                                   'restablecer tu contraseña en '    \
                                   'unos minutos. '
    end

    it "Should send an email" do
      ActionMailer::Base.deliveries = []
      visit new_user_password_path

      fill_in "user[email]", with: user.email
      find('[name=commit]').click

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "Should show error alert when given email doen not exist" do
      visit new_user_password_path

      fill_in "user[email]", with: "nonexistent@email.com"
      find('[name=commit]').click

      expect(page).to have_content 'Email no se ha encontrado.'
    end
  end
end
