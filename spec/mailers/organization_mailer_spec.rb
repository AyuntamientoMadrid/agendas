describe OrganizationMailer, type: :mailer do

  let(:user) { create(:user, :lobby, password: "qwer1234", password_confirmation: "qwer1234") }
  let(:organization) { create(:organization, user: user) }

  describe "Welcome" do
    let(:mail) { OrganizationMailer.welcome(organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq([organization.user.email])
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have welcome subject including lobby id" do
      expect(mail.subject).to eq(I18n.t('mailers.create_organization.subject', lobby_name: organization.fullname))
    end

    it "should include organization information" do
      expect(mail.body).to match(organization.name)
      expect(mail.body).to match(I18n.l(organization.inscription_date, format: :short))
    end

    it "should include organization user credentials" do
      expect(mail.body).to match(organization.user.email)
      expect(mail.body).to match("qwer1234")
    end

    it "should include password reset notice" do
      expect(mail.body).to match(I18n.t('mailers.create_organization.text6'))
    end

    it "should include responsible statements information" do
      expect(mail.body).to match(I18n.t('mailers.create_organization.text7'))
    end

    it "should include features of lobbies registry" do
      expect(mail.body).to include(I18n.t('mailers.create_organization.text8'))
      expect(mail.body).to include(I18n.t('mailers.create_organization.text9'))
      expect(mail.body).to match(I18n.t('mailers.create_organization.text10'))
      expect(mail.body).to match(I18n.t('mailers.create_organization.text11'))
    end
  end

  describe "Delete" do

    before{ organization.update(canceled_at: Time.current) }
    let(:mail) { OrganizationMailer.delete(organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq([organization.user.email])
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including lobby reference" do
      expect(mail.subject).to eq(I18n.t('mailers.delete_organization.subject', lobby_name: organization.fullname))
    end

    it "should include account deletetion information" do
      expect(mail.body).to match(I18n.t('mailers.delete_organization.head2'))
    end

    it "should include cancelation time information" do
      expect(mail.body).to match(I18n.l(organization.canceled_at, format: :long))
    end
  end

  describe "Invalidate" do
    before{ organization.update(invalidated_at: Time.current, invalidated_reasons: "Reasons to invalidate") }
    let(:mail) { OrganizationMailer.invalidate(organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq([organization.user.email])
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including organization reference" do
      expect(mail.subject).to eq(I18n.t('mailers.invalidate_organization.head1', lobby_name: organization.fullname))
    end

    it 'should show deactivation information' do
      expect(mail.body).to match(I18n.t('mailers.invalidate_organization.text2'))
    end

    it 'should show deactivation date' do
      expect(mail.body).to match(I18n.l(organization.invalidated_at, format: :long))
    end

  end

  describe "Update" do
    before { organization.update(modification_date: Date.current) }
    let(:mail) { OrganizationMailer.update(organization) }

    it "should be send from default from" do
      expect(mail.from).to eq(["no-reply@madrid.es"])
    end

    it "should be send to organization user (contact person)" do
      expect(mail.to).to eq([organization.user.email])
    end

    it "should send a copy to registrodelobbies@madrid.es" do
      expect(mail.bcc).to eq(['registrodelobbies@madrid.es'])
    end

    it "should have subject including organization reference" do
      expect(mail.subject).to eq(I18n.t('mailers.update_organization.subject', lobby_name: organization.fullname))
    end

    it 'should show modification information' do
      expect(mail.body).to match(I18n.t('mailers.update_organization.head2'))
    end

    it 'should show modification date' do
      expect(mail.body).to match(I18n.l(organization.modification_date, format: :long))
    end

  end
end
