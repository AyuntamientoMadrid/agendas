feature 'Organizations Mailer' do

  describe "Create Organization" do
    background do
      @organization = create(:organization)
      OrganizationMailer.create(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'create event mail' do
      expect(current_email).to have_content @organization.user_name
      expect(current_email).to have_content @organization.name
      expect(current_email).to have_content @organization.inscription_date
      expect(current_email.subject).to have_content I18n.t('mailers.create_organization.subject', lobby_reference: @organization.id)
    end

  end

  describe "Delete Organization" do
    background do
      @organization = create(:organization, name: "Test name", canceled_at: Time.zone.now)
      OrganizationMailer.delete(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'delete event mail' do
      expect(current_email).to have_content @organization.name
      expect(current_email).to have_content I18n.l(@organization.canceled_at, format: :long)
      expect(current_email.subject).to have_content I18n.t('mailers.delete_organization.subject', lobby_reference: @organization.id)
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

  describe "Update Organization" do
    background do
      @organization = create(:organization, modification_date: Time.zone.now)
      OrganizationMailer.update(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'update organization mail' do
      expect(current_email).to have_content @organization.name
      expect(current_email).to have_content I18n.l(@organization.modification_date, format: :long)
      expect(current_email.subject).to have_content I18n.t('mailers.update_organization.subject', lobby_reference: @organization.id)

    end

  end
end
