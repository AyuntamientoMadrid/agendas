feature 'Organizations page' do

  describe "Index" do

    scenario 'Should show page title' do
      visit organizations_path

      expect(page).to have_content I18n.t 'organizations.title'
      expect(page).to have_content I18n.t 'organizations.description'
    end

    scenario 'Should show each organization name and inscription date', :search do
      organization = create(:organization)
      Organization.reindex

      visit organizations_path

      expect(page).to have_content organization.name
      expect(page).to have_content I18n.l(organization.inscription_date, format: :complete)
    end

    scenario 'Should not show paginator when there are less than 10 results' do
      visit organizations_path

      expect(page).not_to have_selector ".pagination"
    end

    scenario 'Should show paginator when there are more than 11 results', :search do
      organizations = create_list(:organization, 11)
      Organization.reindex

      visit organizations_path

      expect(page).to have_selector ".pagination"
    end

    scenario 'Should navigate to organization public page when user clicks organization name link', :search do
      skip "organization show is not yet implemented"
      organizations = create(:organization)
      Organization.reindex

      visit organizations_path

      expect(page).to have_selector ".pagination"
      expect(page).to have_content organization.title
    end
  end

end
