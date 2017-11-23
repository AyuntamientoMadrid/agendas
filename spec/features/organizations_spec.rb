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
      create_list(:organization, 11)
      Organization.reindex

      visit organizations_path

      expect(page).to have_selector ".pagination"
    end

    scenario 'Should navigate to organization public page when user clicks organization name link', :search do
      skip "organization show is not yet implemented"
      organization = create(:organization)
      Organization.reindex

      visit organizations_path

      expect(page).to have_selector ".pagination"
      expect(page).to have_content organization.title
    end

    describe "Search form", :search do
      scenario "Should filter by given keyword over organizations name and show result" do
        organization = create(:organization, name: "Hola", first_name: "", last_name: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Hola"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Hola"
        end
      end

      scenario "Should filter by given keyword over organizations name and show result" do
        organization = create(:organization, name: "", first_name: "Fulanito", last_name: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito"
        end
      end

      scenario "Should filter by given keyword over organizations name and show result" do
        organization = create(:organization, name: "", first_name: "Fulanito", last_name: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "de Tal"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "de Tal"
        end
      end

      scenario "Should filter by given keywords over organizations name and show result" do
        organization = create(:organization, name: "", first_name: "Fulanito", last_name: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito de Tal"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "de Tal"
        end
      end

      scenario "Should reset search form when user clicks reset form button" do
        organization = create(:organization, name: "", first_name: "Fulanito", last_name: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito de Tal"
        expect(find('#keyword').value).to eq "Fulanito de Tal"

        click_on "Cancelar"

        expect(find('#keyword').value).to eq nil
      end
    end

  end

end
