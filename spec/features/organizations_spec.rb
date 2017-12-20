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

    scenario 'Should show only organization with canceled_at nil', :search do
      organization1 = create(:organization, canceled_at: nil)
      organization2 = create(:organization, canceled_at: Date.current)
      Organization.reindex

      visit organizations_path

      expect(page).to have_content organization1.name
      expect(page).to have_content organization2.name
    end

    scenario "Should show invalidated organizations", :search do
      create(:organization, name: "Valid Org 1")
      organization = create(:organization, name: "Invalid Org 2")
      organization.update(invalidated_reasons: 'test')
      organization.update(invalidated_at: Time.zone.today)

      Organization.reindex

      visit organizations_path
      expect(page).to have_content "Invalid Org 2"
      expect(page).to have_content "Valid Org 1"
    end

    scenario 'Should not show paginator when there are less than 20 results' do
      visit organizations_path

      expect(page).not_to have_selector ".pagination"
    end

    scenario 'Should show paginator when there are more than 20 results', :search do
      create_list(:organization, 21)
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
        click_on "Limpiar"

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
        organization.update(invalidated_reasons: 'test')
        organization.update(invalidated_at: Time.zone.today)

        Organization.reindex

        visit organizations_path
        expect(page).to have_content "Invalid Org 2"
        expect(page).to have_content "Valid Org 1"
      end

      scenario "Should display results with entity_type: lobby", :js do
        create(:organization, entity_type: :federation, name: "Federación 1")
        create(:organization, entity_type: :association, name: "Asociación 1")
        create(:organization, entity_type: :lobby, name: "Lobby 1")
        Organization.reindex

        visit organizations_path

        expect(page).to have_content "Lobby 1"
        expect(page).not_to have_content "Asociación 1"
        expect(page).not_to have_content "Federación 1"
      end

      scenario "Should display events as lobby and status :done", :js do
        organization = create(:organization, entity_type: :lobby)
        event1 = create(:event, lobby_activity: true, organization: organization)
        event2 = create(:event, lobby_activity: true, organization: organization)
        event3 = create(:event, lobby_activity: false, organization: organization)
        event3.update(status: :requested)
        event2.update(status: :accepted)
        event1.update(status: :done)

        Organization.reindex

        visit organizations_path

        expect(page).to have_content "Reuniones realizadas: 1"
      end

      scenario "Should filter by given keyword over organization agents name and show result" do
        organization = create(:organization, name: "Fulanito", entity_type: :lobby)
        create(:organization, name: "Menganito", entity_type: :lobby)
        agent = create(:agent)
        organization.agents << agent
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "#{agent.name}"
        click_on "Buscar"

        within "#organization_#{organization.id}" do
          expect(page).to have_content "Fulanito"
        end
        expect(page).not_to have_content "Menganito"
      end

      scenario "Should filter by given keyword over canceled organization agents name and not display result" do
        agent = create(:agent)
        organization_canceled = create(:organization, name: "Fulanito", entity_type: :lobby, canceled_at: Date.yesterday)
        organization_valid = create(:organization, name: "Menganito", entity_type: :lobby)
        organization_canceled.agents << agent
        organization_valid.agents << agent
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "#{agent.name}"
        click_on "Buscar"

        within "#organization_#{organization_valid.id}" do
          expect(page).to have_content "Menganito"
        end
        expect(page).not_to have_content "Fulatino"
      end

      scenario "Should filter by given keyword over invalid organization agents name and not display result" do
        agent = create(:agent)
        organization_invalid = create(:organization, name: "Fulanito", entity_type: :lobby)
        organization_invalid.update(invalidate: true)
        organization_valid = create(:organization, name: "Menganito", entity_type: :lobby)
        organization_invalid.agents << agent
        organization_valid.agents << agent
        Organization.reindex

        visit organizations_path
        fill_in :keyword, with: "#{agent.name}"
        click_on "Buscar"

        within "#organization_#{organization_valid.id}" do
          expect(page).to have_content "Menganito"
        end
        expect(page).not_to have_content "Fulatino"
      end
    end

    feature 'Filters' do
      background do
        @org1 = create(:organization, name: "Elon", first_surname: "Musk", inscription_date: 'Fri, 27 Nov 2015')
        @org2 = create(:organization, name: "Nikola", first_surname: "Tesla", inscription_date: 'Sun, 27 Nov 2016')
        Organization.reindex
      end

      context 'Interests' do
        background do
          @org1.interests.push(create(:interest, name: 'Music'))
          @org2.interests.push(create(:interest, name: 'History'))
          Organization.reindex
        end

        scenario 'shows organizations based on the selected interest', :search do
          visit organizations_path

          expect(page).to have_content(@org1.name)
          expect(page).to have_content(@org2.name)

          find('#interestsFilter').find(:xpath, 'option[2]').select_option
          click_button(I18n.t('main.form.search'))

          expect(page).to have_content(@org1.name)
          expect(page).to have_no_content(@org2.name)
        end
      end

      context 'Sorting' do
        scenario 'by ASC name', :search do
          visit organizations_path(order: 1)
          expect(page.body.index(@org1.name)).to be < page.body.index(@org2.name)
        end

        scenario 'by DESC name', :search do
          visit organizations_path(order: 2)
          expect(page.body.index(@org2.name)).to be < page.body.index(@org1.name)
        end

        scenario 'by ASC inscription date', :search do
          visit organizations_path(order: 3)
          expect(page.body.index(@org1.name)).to be < page.body.index(@org2.name)
        end

        scenario 'by DESC inscription date', :search do
          visit organizations_path(order: 4)
          expect(page.body.index(@org2.name)).to be < page.body.index(@org1.name)
        end
      end

      context 'Categories' do
        scenario 'shows organizations based on the selected category', :search do
          visit organizations_path

          expect(page).to have_content(@org1.name)
          expect(page).to have_content(@org2.name)

          find('#categoryFilter').find(:xpath, 'option[2]').select_option
          click_button(I18n.t('main.form.search'))

          expect(page).to have_content(@org1.name)
          expect(page).to have_no_content(@org2.name)
        end
      end

      context 'Agents' do

        background do
          @agent1 = create(:agent, name: "Maria")
          @agent2 = create(:agent, name: "Pedro")
          @org1.agents.push(@agent1)
          @org2.agents.push(@agent2)
          Organization.reindex
        end

        scenario 'shows organizations based on the agent name', :search do
          visit organizations_path

          expect(page).to have_content(@org1.name)
          expect(page).to have_content(@org2.name)

          fill_in :keyword, with: "Maria"
          click_button(I18n.t('main.form.search'))

          expect(page).to have_content(@org1.name)
          expect(page).to have_no_content(@org2.name)

          fill_in :keyword, with: "Pedro"
          click_button(I18n.t('main.form.search'))

          expect(page).to have_content(@org2.name)
          expect(page).to have_no_content(@org1.name)
        end

        scenario 'not shows organizations invalidate based on the agent name', :search do
          @org1.update(invalidated_reasons: 'test')
          @org1.update(invalidated_at: Time.zone.today)

          Organization.reindex
          visit organizations_path

          expect(page).to have_content(@org1.name)

          fill_in :keyword, with: "Maria"
          click_button(I18n.t('main.form.search'))

          expect(page).not_to have_content(@org1.name)
        end

        scenario 'not shows organizations with canceled_at based on the agent name', :search do
          @org1.update(canceled_at: Date.current)
          Organization.reindex
          visit organizations_path

          expect(page).to have_content(@org1.name)

          fill_in :keyword, with: "Maria"
          click_button(I18n.t('main.form.search'))

          expect(page).not_to have_content(@org1.name)
        end

      end
    end

    scenario "Should display organizations with event with lobby_activity", :search do
      organization_one = create(:organization, entity_type: :lobby, name: "Organizacion 1")
      organization_two = create(:organization, entity_type: :lobby, name: "No lobby activity")
      event=create(:event,organization: organization_one)
      event.lobby_activity = true
      event.event_agents << create(:event_agent)
      event.save!
      event_two = create(:event, lobby_activity: false, organization: organization_two)
      event_two.lobby_activity = false
      event_two.event_agents << create(:event_agent)
      event_two.save!
      Organization.reindex

      visit organizations_path
      find(:css, "#lobby_activity[value='1']").set(true)
      click_button(I18n.t('main.form.search'))

      expect(page).to have_content "Organizacion 1"
      expect(page).not_to have_content "No lobby activity"
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

    describe "organization status" do
      scenario "Should display organization status active" do
        organization = create(:organization)

        visit organization_path(organization)

        expect(page).to have_content "Estado Activo"
      end

      scenario "Should display organization canceled" do
        organization = create(:organization, canceled_at: Date.current)

        visit organization_path(organization)

        expect(page).to have_content "Estado Baja"
      end

      scenario "Should display organization invalidate" do
        organization = create(:organization)
        organization.update(invalidate: true)

        visit organization_path(organization)

        expect(page).to have_content "Estado Baja"
      end
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

      expect(page).to have_content organization.name
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

      expect(page).to have_content "Datos de quien va a ejercer la actividad de lobby por cuenta propia"
      expect(page).to have_content organization.fiscal_year
      expect(organization.range_fund).to eq('range_1')
      expect(organization.subvention).to eq(false)
      expect(organization.contract).to eq(true)
    end

    scenario "Should display organization represented_entity lobby info" do
      organization = create(:organization)
      represented_entity1 = create(:represented_entity, organization: organization)
      represented_entity2 = create(:represented_entity, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content represented_entity1.identifier
      expect(page).to have_content represented_entity1.fullname
      expect(page).to have_content I18n.l(represented_entity1.from)
      expect(page).to have_content I18n.l(represented_entity1.to)
      expect(page).to have_content represented_entity1.fiscal_year
      expect(represented_entity1.range_fund).to eq('range_1')
      expect(represented_entity1.subvention).to eq(false)
      expect(represented_entity1.contract).to eq(true)

      expect(page).to have_content represented_entity2.identifier
      expect(page).to have_content represented_entity2.fullname
      expect(page).to have_content I18n.l(represented_entity2.from)
      expect(page).to have_content I18n.l(represented_entity2.to)
      expect(page).to have_content represented_entity2.fiscal_year
      expect(represented_entity2.range_fund).to eq('range_1')
      expect(represented_entity2.subvention).to eq(false)
      expect(represented_entity2.contract).to eq(true)
    end

    scenario "Should display organization agent info" do
      organization = create(:organization)
      agent1 = create(:agent, organization: organization)
      agent2 = create(:agent, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content I18n.l(agent1.from)
      expect(page).to have_content agent1.fullname
      expect(page).to have_content I18n.l(agent1.to)

      expect(page).to have_content I18n.l(agent2.from)
      expect(page).to have_content agent2.fullname
      expect(page).to have_content I18n.l(agent2.to)
    end

    scenario "Should display canceled organization but not display agent info" do
      organization = create(:organization, canceled_at: Date.current)
      agent = create(:agent, organization: organization)

      visit organization_path(organization)

      expect(page).to have_content organization.name
      expect(page).not_to have_content agent.fullname
    end

    scenario "Should display invalidate organization but not display agent info" do
      organization = create(:organization)
      agent = create(:agent, organization: organization)
      organization.update(invalidate: true)

      visit organization_path(organization)

      expect(page).to have_content organization.name
      expect(page).not_to have_content agent.fullname
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

    scenario "Should display organization event" do
      organization = create(:organization)
      event1 = create(:event)
      event2 = create(:event)
      organization.events << event1
      organization.events << event2

      visit organization_path(organization)

      expect(page).to have_content event1.title
      expect(page).to have_content event2.title
    end

    scenario "Should return to organizations index page" do
      organization = create(:organization)
      visit organization_path(organization)

      click_on "Volver"

      expect(page).to have_content("Consulta del Registro de Lobbies")
    end

  end

  describe "New (remote)" do

    scenario 'Should show page title' do
      visit new_organization_path

      expect(page).to have_content I18n.t 'organizations.new.title'
    end

  end
end
