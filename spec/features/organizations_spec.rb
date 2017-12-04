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
      organization = create(:organization)

      Organization.reindex

      visit organizations_path

      click_on organization.fullname

      expect(page).to have_content organization.fullname
    end

    describe "Search form", :search do

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

      scenario "Shouldn't show invalidated organizations" do
        create(:organization, name: "Valid Org 1")
        organization = create(:organization, name: "Invalid Org 2")
        organization.update(invalidate: true)

        Organization.reindex

        visit organizations_path
        expect(page).not_to have_content "Invalid Org 2"
        expect(page).to have_content "Valid Org 1"
      end

      scenario "Should filter by selected entity_type" do
        create(:organization, entity_type: 'federation', name: "Federación 1")
        create(:organization, entity_type: 'association', name: "Asociación 1")
        create(:organization, entity_type: 'lobby', name: "Lobby 1")
        Organization.reindex

        visit organizations_path
        all('#entity_type option')[1].select_option
        click_on "Buscar"
        expect(page).not_to have_content "Lobby 1"
        expect(page).to have_content "Asociación 1"
        expect(page).not_to have_content "Federación 1"

        visit organizations_path
        all('#entity_type option')[2].select_option
        click_on "Buscar"
        expect(page).not_to have_content "Lobby 1"
        expect(page).not_to have_content "Asociación 1"
        expect(page).to have_content "Federación 1"

        visit organizations_path
        all('#entity_type option')[3].select_option
        click_on "Buscar"
        expect(page).to have_content "Lobby 1"
        expect(page).not_to have_content "Asociación 1"
        expect(page).not_to have_content "Federación 1"

        visit organizations_path
        all('#entity_type option')[0].select_option
        click_on "Buscar"
        expect(page).to have_content "Lobby 1"
        expect(page).to have_content "Asociación 1"
        expect(page).to have_content "Federación 1"
      end
    end

    scenario 'Should be go to show page when click on organization', :search do
      organization = create(:organization)
      Organization.reindex

      visit organizations_path
      find("#organization_#{organization.id}").click

      expect(page).to have_content organization.name
    end

    describe "Export link" do
      scenario "Should generate CSV file with organizations" do
        visit organizations_path

        click_link "Exportar"

        expect(page.status_code).to eq 200
        expect(page.response_headers['Content-Type']).to eq "text/csv; charset=utf-8"
      end

      scenario "Should include only search results", :search do
        organizations = create_list(:organization, 2)
        Organization.reindex
        visit organizations_path
        fill_in :keyword, with: organizations.first.name
        click_on "Buscar"

        click_link "Exportar"

        expect(page).to have_content organizations.first.name
        expect(page).not_to have_content organizations.last.name
      end
    end

  end

  describe "Show" do

    scenario "Should display organization title and id" do
      organization = create(:organization)

      visit organization_path(organization)

      expect(page).to have_content "Organización"
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

      expect(page).to have_content "Datos de quien va a ejercer la actividad de lobby por cuenta propria"
      expect(page).to have_content organization.fiscal_year
      expect(page).to have_content organization.range_fund
      expect(page).to have_content organization.subvention
      expect(page).to have_content organization.contract
    end

    scenario "Should display organization represented_entity lobby info" do
      organization = create(:organization)
      represented_entity1 = create(:represented_entity, organization: organization)
      represented_entity2 = create(:represented_entity, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content represented_entity1.identifier
      expect(page).to have_content represented_entity1.fullname
      expect(page).to have_content represented_entity1.from
      expect(page).to have_content represented_entity1.to
      expect(page).to have_content represented_entity1.fiscal_year
      expect(page).to have_content represented_entity1.range_fund
      expect(page).to have_content represented_entity1.subvention
      expect(page).to have_content represented_entity1.contract

      expect(page).to have_content represented_entity2.identifier
      expect(page).to have_content represented_entity2.fullname
      expect(page).to have_content represented_entity2.from
      expect(page).to have_content represented_entity2.to
      expect(page).to have_content represented_entity2.fiscal_year
      expect(page).to have_content represented_entity2.range_fund
      expect(page).to have_content represented_entity2.subvention
      expect(page).to have_content represented_entity2.contract
    end

    scenario "Should display organization agent info" do
      organization = create(:organization)
      agent1 = create(:agent, organization: organization)
      agent2 = create(:agent, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content agent1.from
      expect(page).to have_content agent1.fullname
      expect(page).to have_content agent1.to

      expect(page).to have_content agent2.from
      expect(page).to have_content agent2.fullname
      expect(page).to have_content agent2.to
    end

    scenario "Should display organization interest" do
      organization = create(:organization)
      interest1 = create(:interest)
      interest2 = create(:interest)
      organization.interests << interest1
      organization.interests << interest2

      visit organization_path(organization)

      expect(page).to have_content interest1.name
      expect(page).to have_content interest2.name
    end

    scenario "Should return to organizations index page" do
      organization = create(:organization)
      visit organization_path(organization)

      click_on "Volver"

      expect(page).to have_content("Consulta del registro de Organizaciones")
    end

    scenario "Should order by inscription date ascending", :search do
      create(:organization, name: "Carlos", first_surname: "Peréz", inscription_date: "Sat, 27 Nov 2015")
      create(:organization, name: "Fulanito", first_surname: "Mengano", inscription_date: "Sun, 27 Nov 2016")
      Organization.reindex

      visit organizations_path

      page.body.index('Carlos').should < page.body.index('Fulanito')
    end

    scenario "Should order by inscription date descending", :js, :search do
      create(:organization, name: "Carlos", first_surname: "Peréz", inscription_date: "Sat, 27 Nov 2015")
      create(:organization, name: "Fulanito", first_surname: "Mengano", inscription_date: "Sun, 27 Nov 2016")
      Organization.reindex

      visit organizations_path

      all("#search-order option")[1].select_option
      sleep 1

      page.body.index('Fulanito').should < page.body.index('Carlos')
    end

  end

end
