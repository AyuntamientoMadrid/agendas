feature 'Organizations Mailer' do

  describe "Create Organization" do
    background do
      @organization = create(:organization)
      open_email(@organization.user.email)
    end

    scenario 'create event mail' do
      pending("pending remove spec. This email create on UserMailer")
      expect(current_email).to have_content I18n.t('mailers.create_organization.text1', title: @organization.fullname)
    end

  end

  describe "Delete Organization" do
    background do
      organization = create(:organization)
      @fullname = organization.fullname
      organization.destroy
      open_email(organization.user.email)
    end

    scenario 'delete event mail' do
      expect(current_email).to have_content I18n.t('mailers.delete_organization.text1', title: @fullname)
    end

  end

  describe "Invalidate Organization" do
    background do
      @organization = create(:organization)
      @organization.set_invalidate
      open_email(@organization.user.email)
    end

    scenario 'invalidate event mail' do
      skip("unnecessary email")
      expect(current_email).to have_content I18n.t('mailers.invalidate_organization.text1', title: @organization.fullname)
    end

  end
end
