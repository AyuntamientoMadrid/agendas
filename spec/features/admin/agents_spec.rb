feature "Agents" do

  describe "Index" do

    let!(:user)  { create(:user, :user) }
    let!(:lobby) { create(:user, :lobby) }
    let!(:admin) { create(:user, :admin) }
    let!(:organization) { create(:organization, user: lobby) }

    describe "Should not be able" do

      scenario "To holder users" do
        login_as(user)
        visit admin_organization_agents_path(organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

      scenario "To lobby users when accessing through other organizations" do
        login_as(lobby)
        other_organization = create(:organization)
        visit admin_organization_agents_path(other_organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

    end

    describe "Should be able" do

      scenario "To admin users" do
        login_as(admin)
        visit admin_organization_agents_path(organization)

        expect(page).to have_content "Agentes (0)"
      end

      scenario "To lobby users when accessing through own organizations" do
        login_as(lobby)
        visit admin_organization_agents_path(organization)

        expect(page).to have_content "Agentes (0)"
      end

    end

    scenario "Should show only organization agents" do
      login_as(lobby)
      agents = create_list(:agent, 2, organization: organization)
      other_orgaanization_agent = create(:agent)
      visit admin_organization_agents_path(organization)

      expect(page).to have_content agents.first.fullname
      expect(page).to have_content agents.second.fullname
      expect(page).not_to have_content other_orgaanization_agent.fullname
    end

    scenario "Should not show destroy link to lobby users" do
      login_as(lobby)
      agent = create(:agent, organization: organization)
      visit admin_organization_agents_path(organization)

      within "#agent_#{agent.id}" do
        expect(page).not_to have_selector "a i.fi-page-delete"
      end
    end

    scenario "Should show destroy link to admin users" do
      login_as(admin)
      agent = create(:agent)
      visit admin_organization_agents_path(agent.organization)

      within "#agent_#{agent.id}" do
        expect(page).to have_selector "a i.fi-page-delete"
      end
    end

  end

  describe "New" do

    let!(:user)  { create(:user, :user) }
    let!(:lobby) { create(:user, :lobby) }
    let!(:admin) { create(:user, :admin) }
    let!(:organization) { create(:organization, user: lobby) }

    describe "Should not be able" do

      scenario "To holder users" do
        login_as(user)
        visit new_admin_organization_agent_path(organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

      scenario "To lobby users when accessing through other organizations" do
        login_as(lobby)
        other_organization = create(:organization)
        visit new_admin_organization_agent_path(other_organization)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

    end

    describe "Should be able" do

      scenario "To admin users" do
        login_as(admin)
        visit admin_organization_agents_path(organization)

        expect(page).to have_content "Agentes (0)"
      end

      scenario "To lobby users when accessing through own organizations" do
        login_as(lobby)
        visit admin_organization_agents_path(organization)

        expect(page).to have_content "Agentes (0)"
      end

    end

    scenario "Should show validation errors" do
      login_as(admin)
      visit new_admin_organization_agent_path(organization)

      click_button "Guardar"

      expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
      expect(page).to have_content "Archivo no puede estar en blanco"
      expect(page).to have_content "5 errores impidieron guardar este Agente"
      expect(page).to have_content "Nombre no puede estar en blanco"
      expect(page).to have_content "Desde no puede estar en blanco"
      expect(page).to have_content "Acredito el consentimiento expreso de esta persona " \
                                   "para que sus datos meramente identificativos puedan " \
                                   "hacerse públicos Sí No no está incluido en la lista"
      expect(page).to have_content "Debe proporcionar el documento acreditativo de los permisos."
    end

    scenario "Should not initialize tinymce editor" do
      login_as(admin)
      visit new_admin_organization_agent_path(organization)

      expect(page).not_to have_selector "textarea.tinymce"
      expect(page).to have_selector "textarea.mceNoEditor"

      click_button "Guardar"

      expect(page).not_to have_selector "textarea.tinymce"
      expect(page).to have_selector "textarea.mceNoEditor"
    end

  end

  describe "Create" do

    let!(:admin) { create(:user, :admin) }
    let!(:organization) { create(:organization) }

    scenario 'Create organization with valid agents', :js do
      login_as admin
      visit new_admin_organization_agent_path(organization)

      fill_in "Nombre", with: "Name"
      fill_in "Desde", with: Date.current
      find(:css, "input[id='agent_allow_public_data_false']").set(true)
      find("input[type=file]").set("spec/fixtures/dummy.jpg")
      click_button "Guardar"

      expect(page).to have_content "Registro creado correctamente"
    end

  end

  describe "Edit" do

    let!(:user)  { create(:user, :user) }
    let!(:lobby) { create(:user, :lobby) }
    let!(:admin) { create(:user, :admin) }
    let!(:organization) { create(:organization, user: lobby) }
    let!(:agent) { create(:agent, organization: organization) }

    describe "Should not be able" do

      scenario "To holder users" do
        login_as(user)
        visit edit_admin_organization_agent_path(organization, agent)

        expect(page).to have_content "No dispone de privilegios suficientes para realizar esta operación"
      end

    end

    describe "Should be able" do

      scenario "To admin users" do
        login_as(admin)
        visit edit_admin_organization_agent_path(organization, agent)

        expect(page).to have_content "Editar agente"
      end

      scenario "To lobby users when accessing through own organizations" do
        login_as(lobby)
        visit edit_admin_organization_agent_path(organization, agent)

        expect(page).to have_content "Editar agente"
      end

    end

    scenario "Should show validation errors" do
      login_as admin
      visit edit_admin_organization_agent_path(organization, agent)

      fill_in :agent_name, with: nil
      fill_in :agent_from, with: nil
      click_button "Guardar"

      expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
      expect(page).to have_content "2 errores impidieron guardar este Agente"
      expect(page).to have_content "Nombre no puede estar en blanco"
      expect(page).to have_content "Desde no puede estar en blanco"
    end

    scenario "Should initialize tinymce editor" do
      login_as(admin)
      visit edit_admin_organization_agent_path(organization, agent)

      expect(page).to have_selector "textarea.tinymce"
    end
  end

  describe "Update" do

    let!(:admin)        { create(:user, :admin) }
    let!(:organization) { create(:organization) }
    let!(:agent)        { create(:agent, organization: organization) }

    scenario 'Should show update notice when agent is valid' do
      new_date = Time.zone.today
      login_as admin
      visit edit_admin_organization_agent_path(organization, agent)

      # mandatory fields
      fill_in :agent_name, with: "New name"
      fill_in :agent_from, with: new_date
      # optional fields
      fill_in :agent_first_surname, with: "new first surname"
      fill_in :agent_second_surname, with: "new second surname"
      fill_in :agent_to, with: new_date
      fill_in :agent_public_assignments, with: "New public assignments"
      click_button "Guardar"

      agent.reload
      expect(page).to have_content "Registro actualizado correctamente"
      expect(agent.name).to eq "New name"
      expect(agent.from).to eq new_date
      expect(agent.first_surname).to eq "new first surname"
      expect(agent.second_surname).to eq "new second surname"
      expect(agent.to).to eq new_date
      expect(agent.public_assignments).to eq "New public assignments"
    end
  end

  describe "Destroy" do

    let!(:admin) { create(:user, :admin) }
    let!(:agent) { create(:agent) }

    scenario "Should be allowed to admin users" do
      login_as(admin)
      visit admin_organization_agents_path(agent.organization)

      within "#agent_#{agent.id}" do
        find('.delete-agent').click
      end

      expect(page).not_to have_content agent.fullname
      expect(page).to have_content("Registro eliminado correctamente")
    end

  end

end
