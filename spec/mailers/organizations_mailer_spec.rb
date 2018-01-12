feature 'Organizations Mailer' do

  describe "Create Organization" do
    background do
      @organization = create(:organization)
      open_email(@organization.user.email)
    end

    scenario 'create event mail' do
      pending("pending remove spec. This email create on UserMailer")
      expect(current_email).to have_content I18n.t('mailers.create_organization.text1')
    end

  end

  describe "Delete Organization" do
    background do
      @organization = create(:organization, name: "Test name", canceled_at: Time.zone.now)
      OrganizationMailer.delete(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'delete event mail' do
      expect(current_email).to have_content I18n.t('mailers.delete_organization.text1', lobby_reference: @lobby_reference)
      expect(current_email).to have_content I18n.t('mailers.delete_organization.head2')
      expect(current_email).to have_content @organization.name
    end

  end

  describe "Invalidate Organization" do
    background do
      @organization = create(:organization, invalidated_at: Time.zone.now, invalidated_reasons: "Test")
      @organization.set_invalidate
      open_email(@organization.user.email)
    end

    scenario 'invalidate event mail' do
      skip("unnecessary email")
      expect(current_email).to have_content I18n.t('mailers.invalidate_organization.text1')
    end

  end
end
