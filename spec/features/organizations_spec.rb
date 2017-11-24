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
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Hola"
        end
      end

      scenario "Should filter by given keyword over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito"
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito"
        end
      end

      scenario "Should filter by given keyword over organizations first_surname and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Mengano"
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano"
        end
      end

      scenario "Should filter by given keywords over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "de Tal"
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano de Tal"
        end
      end

      scenario "Should filter by given keywords over organizations name and show result" do
        organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito Mengano de Tal"
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito Mengano de Tal"
        end
      end

      scenario "Should reset search form when user clicks reset form button" do
        create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Fulanito"
        expect(find('#keyword').value).to eq "Fulanito"
        click_on "Buscar"
        click_on "Cancelar"

        expect(find('#keyword').value).to eq nil
      end

      scenario "Should show number of results by given keywords" do
        create(:organization, name: "Hola", first_surname: "", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Hola"
        click_on "Buscar"

        expect(page).to have_content "1 Resultados con la palabra Hola"
      end

      scenario "Should show number of results by given keywords", :js do
        create(:organization, name: "Hola", first_surname: "", second_surname: "")
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "Hola"
        click_on "Buscar"

        find('#delete-keywords').click
        expect(page).not_to have_content "1 Resultados con la palabra Hola"
        expect(find('#keyword').value).to eq ""
      end
    end

    scenario 'Should be go to show page when click on organization', :search do
      organization = create(:organization)
      Organization.reindex

      visit organizations_path
      find("#organization_#{organization.id}").click

      expect(page).to have_content organization.name
    end
  end

  describe "Show" do

    scenario "Should display organization title and id" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).to have_content "Organizacion"
      expect(page).to have_content organization.id
    end

    scenario "Should display organization data" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).to have_content organization.identifier
      expect(page).to have_content organization.name
      expect(page).to have_content organization.web
      expect(page).to have_content organization.category.name
      expect(page).to have_content organization.address
      expect(page).to have_content organization.postal_code
      expect(page).to have_content organization.town
      expect(page).to have_content organization.province
      expect(page).to have_content organization.description
    end

    scenario "Should not display some organization data" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).not_to have_content organization.phones
      expect(page).not_to have_content organization.email
      expect(page).not_to have_content organization.registered_lobbies
    end

    scenario "Should display organization legal_representant" do
      organization = create(:organization)
      legal_representant = create(:legal_representant, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content legal_representant.fullname
    end

    scenario "Should not display some legal_representant info" do
      organization = create(:organization)
      legal_representant = create(:legal_representant, organization: organization)

      visit organization_path(organization)

      expect(page).not_to have_content legal_representant.identifier
      expect(page).not_to have_content legal_representant.phones
      expect(page).not_to have_content legal_representant.email
    end

    scenario "Should display organization user info" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).to have_content organization.user.name
    end

    scenario "Should not display some user info" do
      user = create(:user, :lobby)
      organization = create(:organization, user: user)

      visit organization_path(organization)

      expect(page).not_to have_content organization.user.phones
      expect(page).not_to have_content organization.user.email
    end

    scenario "Should display organization lobby info" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).to have_content "Datos economicos"
      expect(page).to have_content organization.fiscal_year
      expect(page).to have_content organization.range_fund
      expect(page).to have_content organization.subvention
      expect(page).to have_content organization.contract
    end

    scenario "Should display organization represented_entity lobby info" do
      organization = create(:organization)
      represented_entity_1 = create(:represented_entity, organization: organization)
      represented_entity_2 = create(:represented_entity, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content represented_entity_1.identifier
      expect(page).to have_content represented_entity_1.fullname
      expect(page).to have_content represented_entity_1.from
      expect(page).to have_content represented_entity_1.to
      expect(page).to have_content represented_entity_1.fiscal_year
      expect(page).to have_content represented_entity_1.range_fund
      expect(page).to have_content represented_entity_1.subvention
      expect(page).to have_content represented_entity_1.contract

      expect(page).to have_content represented_entity_2.identifier
      expect(page).to have_content represented_entity_2.fullname
      expect(page).to have_content represented_entity_2.from
      expect(page).to have_content represented_entity_2.to
      expect(page).to have_content represented_entity_2.fiscal_year
      expect(page).to have_content represented_entity_2.range_fund
      expect(page).to have_content represented_entity_2.subvention
      expect(page).to have_content represented_entity_2.contract
    end

    scenario "Should display organization agent info" do
      organization = create(:organization)
      agent_1 = create(:agent, organization: organization)
      agent_2 = create(:agent, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content agent_1.from
      expect(page).to have_content agent_1.fullname
      expect(page).to have_content agent_1.to

      expect(page).to have_content agent_2.from
      expect(page).to have_content agent_2.fullname
      expect(page).to have_content agent_2.to
    end

    scenario "Should display organization interest" do
      organization = create(:organization)
      interest_1 = create(:interest)
      interest_2 = create(:interest)
      organization.interests << interest_1
      organization.interests << interest_2

      visit organization_path(organization)

      expect(page).to have_content interest_1.name
      expect(page).to have_content interest_2.name
    end

  end

end
