feature 'Organization' do

  describe 'User admin' do
    background do
      user_admin = create(:user, :admin)
      signin(user_admin.email, user_admin.password)
    end

    scenario 'Visit admin page and display organization button on sidebar' do
      visit admin_path

      expect(page).to have_content "Organizaciones"
    end

    describe "Index" do

      scenario 'visit admin page and organization button render organization index' do
        visit admin_path

        click_link "Organizaciones"

        expect(page).to have_content "Nueva organización"
      end

      scenario 'visit admin index organization page and new organization link render organization new' do
        visit admin_organizations_path

        click_link "Nueva organización"

        expect(current_path).to eq(new_admin_organization_path)
      end

    end

    describe "New" do

      scenario 'Visit new admin organization page and display content' do
        visit new_admin_organization_path

        expect(page).to have_content "Añadir legal representant"
        expect(page).to have_content "Añadir Entidades a las que se representa"
        expect(page).to have_content "Añadir Agentes"
        expect(page).to have_button "Guardar"
      end

    end

    describe "Create" do

      scenario 'Visit new admin organization page and create organization without user and display error' do
        visit new_admin_organization_path

        fill_in :organization_name, with: "organization name"

        click_button "Guardar"

        expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
      end

      scenario 'Visit new admin organization page and create organization with the minimum permitted fields' do
        visit new_admin_organization_path

        fill_in :organization_name, with: "organization name"
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        click_button "Guardar"

        expect(page).to have_content "Registro creado correctamente"
      end

      describe "Nested fields" do

        describe "Legal Representant" do

          scenario 'Try create organization with invalid legal representant and display error', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"
            click_on "Añadir legal representant"
            fill_in :organization_legal_representant_attributes_identifier, with: "43138883z"
            fill_in :organization_legal_representant_attributes_name, with: "Name"
            fill_in :organization_legal_representant_attributes_first_surname, with: "First name"
            fill_in :organization_legal_representant_attributes_email, with: nil
            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
          end

          scenario 'Create organization with valid legal representant', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"
            click_on "Añadir legal representant"
            fill_in :organization_legal_representant_attributes_identifier, with: "43138883z"
            fill_in :organization_legal_representant_attributes_name, with: "43138883z"
            fill_in :organization_legal_representant_attributes_first_surname, with: "43138883z"
            fill_in :organization_legal_representant_attributes_email, with: "valid@email.com"
            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Only add one legal representant', :js do
            visit new_admin_organization_path

            click_on "Añadir legal representant"

            expect(page).not_to have_content "Añadir legal representant"
          end

          scenario 'Display remove button after add one legal representant', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_legal_representant .remove_fields"
            click_on "Añadir legal representant"

            expect(page).to have_selector "#new_legal_representant .remove_fields"
          end

        end

        describe "Represented Entities" do

          scenario 'Try create organization with invalid respresented entities and display error', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Entidades a las que se representa"

            within "#new_represented_entity" do
              fill_in "DNI, NIF, NIE", with: "43138883z"
              fill_in "Nombre o razón social", with: "Name"
              fill_in "Ejercicio anual", with: 2017
              fill_in "Fecha de inicio de la representaciòn", with: nil
            end

            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
          end

          scenario 'Create organization with valid represented entities', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Entidades a las que se representa"

            within "#new_represented_entity" do
              fill_in "DNI, NIF, NIE", with: "43138883z"
              fill_in "Nombre o razón social", with: "Name"
              fill_in "Ejercicio anual", with: 2017
              fill_in "Fecha de inicio de la representaciòn", with: Date.current
            end

            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Can adding more than one represented entity', :js do
            visit new_admin_organization_path

            click_on "Añadir Entidades a las que se representa"

            expect(page).to have_content "Añadir Entidades a las que se representa"
          end

          scenario 'Display remove button after add represented entity', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_represented_entity .remove_fields"
            click_on "Añadir Entidades a las que se representa"

            expect(page).to have_selector "#new_represented_entity .remove_fields"
          end

          scenario 'Display remove button after add more than one represented entity', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_represented_entity .remove_fields"
            click_on "Añadir Entidades a las que se representa"
            click_on "Añadir Entidades a las que se representa"

            expect(page).to have_selector "#new_represented_entity .remove_fields", count: 2
          end
        end

        describe "Agents" do

          scenario 'Try create organization with invalid agent and display error', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Agentes"

            within "#new_agent" do
              fill_in "DNI, NIE, NIF", with: "43138883z"
              fill_in "Nombre", with: "Name"
              fill_in "Desde", with: nil
            end

            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
          end

          scenario 'Create organization with valid agents', :js do
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Agentes"

            within "#new_agent" do
              fill_in "DNI, NIE, NIF", with: "43138883z"
              fill_in "Nombre", with: "Name"
              fill_in "Desde", with: Date.current
            end

            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Can adding more than one agent', :js do
            visit new_admin_organization_path

            click_on "Añadir Agentes"

            expect(page).to have_content "Añadir Agentes"
          end

          scenario 'Display remove button after add agent', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_agent .remove_fields"
            click_on "Añadir Agentes"

            expect(page).to have_selector "#new_agent .remove_fields"
          end

          scenario 'Display remove button after add more than one agent', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_agent .remove_fields"
            click_on "Añadir Agentes"
            click_on "Añadir Agentes"

            expect(page).to have_selector "#new_agent .remove_fields", count: 2
          end

        end
      end

    end

  end

  describe "Manager" do

    background do
      manager = create(:user, :user)
      signin(manager.email, manager.password)
    end

    scenario 'Visit manager backend page and not display organization button on sidebar' do
      visit admin_path

      expect(page).not_to have_content "Organizaciones"
    end

  end

  describe "Lobby" do

    background do
      lobby = create(:user, :lobby)
      signin(lobby.email, lobby.password)
    end

    scenario 'Visit lobby backend page and not display organization button on sidebar' do
      visit admin_path

      expect(page).not_to have_content "Organizaciones"
    end

  end

end
