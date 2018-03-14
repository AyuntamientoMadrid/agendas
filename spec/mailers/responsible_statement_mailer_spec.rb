describe ResponsibleStatementMailer, type: :mailer do

  let(:user) { create(:user, :lobby, password: "qwer1234", password_confirmation: "qwer1234") }
  let(:organization) { create(:organization, user: user) }

  describe "notification_error" do
    let(:new_organization) { create(:organization, user: user) }
    let(:mail) { ResponsibleStatementMailer.notification_error(new_organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq(["registrodelobbies@madrid.es"])
    end

    it "should have welcome subject including lobby id" do
      expect(mail.subject).to eq(I18n.t('mailers.notification_error.subject', lobby_name: new_organization.fullname, reference: new_organization.reference))
    end

    it "should include organization information" do
      allow(new_organization.errors).to receive(:full_messages) { ["Error 1", "Error 2"] }
      expect(mail.body).to match(new_organization.name)
      expect(mail.body).to match("Error 1")
      expect(mail.body).to match("Error 2")
    end
  end

  describe "notification_success" do
    let(:mail) { ResponsibleStatementMailer.notification_success(organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq(["registrodelobbies@madrid.es"])
    end

    it "should have welcome subject including lobby id" do
      expect(mail.subject).to eq(I18n.t('mailers.notification_success.subject', lobby_name: organization.fullname, reference: organization.reference, inscription_date: organization.inscription_date.to_date.to_s))
    end

    it "should include organization information" do
      expect(mail.body).to match(I18n.t('mailers.notification_success.head1', lobby_name: organization.fullname))
    end
  end

end
