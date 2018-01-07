require 'spec_helper'

describe "Passwords" do

  before { Warden.test_reset! }

  describe "New" do

    let!(:user) { create(:user) }

    it "Should send account recovery email when email exists" do
      visit new_user_password_path

      fill_in "user[email]", with: user.email
      find('[name=commit]').click

      expect(page).to have_content 'Recibirás un correo con instrucciones ' \
                                   'sobre cómo resetear tu contraseña en unos ' \
                                   'pocos minutos'
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

      expect(page).to have_content 'Email no se ha encontrado'
    end
  end

  describe "edit" do
    it "should not be able without reset_password_token" do
      visit edit_user_password_path

      expect(page).to have_content "No puedes acceder a esta página si no es a " \
                                   "través de un enlace para resetear tu contraseña. " \
                                   "Si has llegado hasta aquí desde el email para " \
                                   "resetear tu contraseña, por favor asegúrate de " \
                                   "que la URL introducida está completa."
    end

    it "should not be able to reset_password_token with password lenght < 6" do
      user = create :user
      token = request_new_password_and_return_token(user)
      visit edit_user_password_path({reset_password_token: token })

      fill_in "user_password", with: "xxxxx"
      fill_in "user_password_confirmation", with: "xxxxx"
      click_on "Cambiar mi contraseña"

      expect(page).to have_content "Contraseña es demasiado corto (8 caracteres mínimo)"
    end

    it "should not be able to reset_password_token with password lenght < 6" do
      user = create :user
      token = request_new_password_and_return_token(user)
      visit edit_user_password_path({reset_password_token: token })

      fill_in "user_password", with: "xxxxxx"
      fill_in "user_password_confirmation", with: "yyyyyy"
      click_on "Cambiar mi contraseña"
      expect(page).to have_content "Confirmación de la contraseña no coincide"
    end

    it "should reset password when password and password_confirmation are correct and equal" do
      user = create :user
      token = request_new_password_and_return_token(user)
      visit edit_user_password_path({reset_password_token: token })

      fill_in "user_password", with: "88888888"
      fill_in "user_password_confirmation", with: "88888888"
      click_on "Cambiar mi contraseña"

      expect(page).to have_content "Se ha cambiado tu contraseña. Ya iniciaste sesión. "

    end
  end

end

def request_new_password_and_return_token(user)
  visit new_user_password_path
  fill_in "user_email", with: user.email
  click_on "Envíeme las instrucciones para resetear mi contraseña"
  mail = ActionMailer::Base.deliveries.last
  token = mail.text_part.body.decoded.match(/(reset_password_token=(\w|\d|-)*)/)
  token.to_s.split("=").last
end