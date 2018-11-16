require "rails_helper"

describe UserMailer, type: :mailer do

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

  describe "infringement_email" do

    let!(:organization)       { create(:organization) }
    let!(:infringement_email) { InfringementEmail.new(subject: "Infringement subject",
                                                      description: "Infringement description",
                                                      link: "http://www.link.com",
                                                      affected: "What",
                                                      affected_referer: "Referer") }
    let!(:mail)               { UserMailer.infringement_email(infringement_email) }

    it "should send from example" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should send to new buzonlobby@madrid.es" do
      expect(mail.to).to eq(["buzonlobby@madrid.es"])
    end

    it "should contain subject" do
      expect(mail.subject).to eq infringement_email.subject
    end

    it "should contain infringement information" do
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.head1', infringement_reference: infringement_email.id)
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.text1', infringement_reference: infringement_email.id)
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.head2')
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.text2')
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.text3')
      expect(mail.body).to have_content infringement_email.description.html_safe
      expect(mail.body).to have_content I18n.t('mailers.infringement_email.link_html')
      expect(mail.body).to have_content infringement_email.link
      expect(mail.attachments.size).to eq(0)
    end

    it "should contain attachment if present" do
      mail = UserMailer.infringement_email(infringement_email, File.open(Rails.root.join("spec/fixtures/dummy.pdf")))

      expect(mail.attachments.size).to eq(1)
    end

  end

  describe "footer" do

    let!(:organization) { create(:organization) }
    let!(:default_locale) { I18n.locale }

    before do
      I18n.locale = :en
    end

    after do
      I18n.locale = default_locale
    end

    it "displays city council name for standard user emails", :focus do
      mail = UserMailer.welcome(organization.user)

      expect(mail.body).to have_content("Madrid City Council #{Date.current.year}")
      expect(mail.body).to_not have_content("If you do not wish to continue receiving this type of emails")
    end

    it "displays city council name and instructions to deactivate newsletter for newsletters" do
      newsletter = create(:newsletter)
      mail = UserMailer.newsletter(newsletter, organization.email)

      expect(mail.body).to have_content("Madrid City Council #{Date.current.year}")
      expect(mail.body).to have_content("If you do not wish to continue receiving this type of emails")
    end

  end

end
