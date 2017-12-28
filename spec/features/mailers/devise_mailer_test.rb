require 'spec_helper'

describe "Password" do

  describe "#new" do
    let(:user) { create(:user) }
    let(:locale) { :es }

    it "emails user when a password reset is requested" do
      visit new_user_password_path
      fill_in "user[email]", :with => user.email
      find('[name=commit]').click
      open_email(user.email)
      expect(current_email).to have_content 'Alguien ha solicitado un enlace
                                             para cambiar su contraseña'
    end
  end
end
