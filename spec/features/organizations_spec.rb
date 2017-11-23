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
        organization = create(:organization, name: "Hola", first_surname: "", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Hola"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Hola"
        end
      end

      scenario "Should filter by given keyword over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito"
        end
      end

      scenario "Should filter by given keyword over organizations first_surname and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Mengano"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano"
        end
      end

      scenario "Should filter by given keywords over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "de Tal"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano de Tal"
        end
      end

      scenario "Should filter by given keywords over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito Mengano de Tal"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano de Tal"
        end
      end

      scenario "Should reset search form when user clicks reset form button" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito"
        expect(find('#keyword').value).to eq "Fulanito"

        click_on "Cancelar"

        expect(find('#keyword').value).to eq nil
      end
    end

  end

end
