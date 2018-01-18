require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "welcome" do

    let!(:organization) { create(:organization) }
    let!(:mail)         { UserMailer.welcome(organization.user) }

    it "should send from example" do
      expect(mail.from).to eq([ "no-reply@madrid.es"])
    end

    it "should send to new user" do
      expect(mail.to).to eq([organization.user.email])
    end

    it "should contain welcome subject" do
      expect(mail.subject).to eq  I18n.t('mailers.welcome_user.subject')
    end

    it "should contain welcome body" do
      expect(mail.body).to have_content I18n.t('mailers.welcome_user.welcome', name: organization.user.name)
      expect(mail.body).to have_content I18n.t('mailers.welcome_user.text1')
      expect(mail.body).to have_content I18n.t('mailers.welcome_user.text2', email: organization.user.email, password: organization.user.password)
      expect(mail.body).to have_content I18n.t('mailers.welcome_user.thanks')
    end

  end

end
