feature 'Organizations Mailer' do

  describe "Create Organization" do
    background do
      @organization = create(:organization)
      OrganizationMailer.create(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'create organization mail' do
      expect(current_email.to).to eq [@organization.user.email]
      expect(current_email.cc).to eq ["registrodelobbies@madrid.es"]
      expect(current_email).to have_content I18n.t('mailers.create_organization.text1', title: @organization.fullname)
    end

  end

  describe "Delete Organization" do
    background do
      @organization = create(:organization)
      OrganizationMailer.delete(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'delete event mail' do
      expect(current_email.to).to eq [@organization.user.email]
      expect(current_email.cc).to eq ["registrodelobbies@madrid.es"]
      expect(current_email).to have_content I18n.t('mailers.delete_organization.text1', title: @organization.fullname)
    end

  end

  describe "Update Organization" do
    background do
      @organization = create(:organization)
      OrganizationMailer.update(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'update event mail' do
      expect(current_email.to).to eq [@organization.user.email]
      expect(current_email.cc).to eq ["registrodelobbies@madrid.es"]
      expect(current_email).to have_content I18n.t('mailers.update_organization.text1', title: @organization.fullname)
    end

  end

  describe "Invalidate Organization" do
    background do
      @organization = create(:organization)
      OrganizationMailer.invalidate(@organization).deliver_now
      open_email(@organization.user.email)
    end

    scenario 'invalidate event mail' do
      expect(current_email.to).to eq [@organization.user.email]
      expect(current_email.cc).to eq ["registrodelobbies@madrid.es"]
      expect(current_email).to have_content I18n.t('mailers.invalidate_organization.text1', title: @organization.fullname)
    end

  end
end
