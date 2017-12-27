feature 'Organization' do

  describe 'User admin' do

    background do
      user_admin = create(:user, :admin)
      login_as user_admin
    end

    scenario 'Visit admin page and display organization button on sidebar' do
      visit admin_path

      expect(page).to have_content "Lobbies"
    end

    describe "Index" do

      let!(:organizations) { create_list(:organization, 3) }

      describe "Search form", :search do

        scenario "Should filter by given keyword over organizations name and show result" do
          organization = create(:organization, name: "Fulanito")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "Fulanito"
          click_on "Buscar"

          within "#organization_#{organization.id}" do
            expect(page).to have_content "Fulanito"
          end
        end

        scenario "Should filter by given keyword over organizations first_surname and show result" do
          organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "Mengano"
          click_on "Buscar"

          within "#organization_#{organization.id}" do
            expect(page).to have_content "Fulanito Mengano"
          end
        end

        scenario "Should filter by given keywords over organizations name and show result" do
          organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "de Tal"
          click_on "Buscar"

          within "#organization_#{organization.id}" do
            expect(page).to have_content "Fulanito Mengano de Tal"
          end

        end

        scenario "Should filter by given keywords over organizations name and show result" do
          organization = create(:organization, name: "Fulanito", first_surname: "Mengano", second_surname: "de Tal")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "Fulanito Mengano de Tal"
          click_on "Buscar"

          within "#organization_#{organization.id}" do
            expect(page).to have_content "Fulanito Mengano de Tal"
          end
        end

        scenario "Should show number of results by given keywords" do
          create(:organization, name: "Organization name", first_surname: "", second_surname: "")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "Organization name"
          click_on "Buscar"

          expect(page).to have_content "Lobbies (1)"
        end

        scenario "Should reset search form when user clicks reset form button" do
          create(:organization, name: "Fulanito")
          Organization.reindex

          visit admin_organizations_path
          fill_in :keyword, with: "Fulanito"

          expect(find('#keyword').value).to eq "Fulanito"
          click_on "Buscar"
          click_on "Cancelar"
          expect(find('#keyword').value).to eq nil
        end

        scenario "Should display export link" do
          visit admin_organizations_path

          expect(page).to have_link 'Exportar'
        end

      end

      scenario "Should display attachments downloads menu dropdown when organization has any attachment", :js, :search do
        organization = organizations.first
        create(:attachment, organization: organization)
        Organization.reindex
        visit admin_organizations_path

        expect(page).to have_selector ".organization-attachments-dropdown", visible: false
        within "#organization_#{organization.id}" do
          find(".organization-attachments-dropdown-link").click

          expect(page).to have_selector ".organization-attachments-dropdown", visible: true
        end
      end

      scenario 'visit admin page and organization button render organization index', :search do
        Organization.reindex
        visit admin_path

        click_link "Lobbies"

        expect(page).to have_content "Nuevo lobby"
        expect(page).to have_content "#{I18n.t 'backend.companies'} (3)"
      end

      scenario 'visit admin index organization page and new organization link render organization new' do
        visit admin_organizations_path

        click_link "Nuevo lobby"

        expect(current_path).to eq(new_admin_organization_path)
      end

      scenario 'visit admin index organization page and edit organization link render organization edit', :search do
        organization = create(:organization)
        Organization.reindex

        visit admin_organizations_path

        within "#organization_#{organization.id}" do
          find('a[title="Editar"]').click
        end
        expect(page).to have_content I18n.t("backend.reference.title_fieldset")
        # expect(page).to have_field('organization_name', with: organization.name)
      end

      scenario 'Should show organization with canceled_at nil', :search do
        organization1 = create(:organization, canceled_at: nil)
        Organization.reindex

        visit admin_organizations_path

        expect(page).to have_content organization1.name
      end

      scenario 'Should show invalidated organizations', :search do
        organization1 = create(:organization)

        organization1.update(invalidated_at: Time.zone.today)
        organization1.update(invalidated_reasons: 'test')

        Organization.reindex

        visit admin_organizations_path

        expect(page).to have_content organization1.name
      end

    end

    describe "New" do

      scenario 'Visit new admin organization page and display content' do
        visit new_admin_organization_path

        expect(page).to have_content "Añadir representante legal"
        expect(page).to have_content "Añadir Entidades/personas a las que se representa"
        expect(page).to have_button "Guardar"
      end

      describe "Agents" do
        scenario 'Should not display agents link new organization records' do
          visit new_admin_organization_path

          expect(page).not_to have_content "Añadir Agentes"
        end

        scenario 'Should display agents notice for new organization records' do
          visit new_admin_organization_path

          expect(page).to have_content "Podrás crear agentes una vez hayas creado "   \
                                       "el lobby. Completa el formulario y pulsa "    \
                                       "'Guardar', una vez almacenado se habilitará " \
                                       "la opción para añadir agentes."
        end
      end

      describe "Documents" do
        scenario 'Should display add attachment link' do
          visit new_admin_organization_path

          expect(page).to have_content "Archivos adjuntos"
          expect(page).to have_link "Añadir archivo adjunto"
        end

        scenario 'Should add new attachment file attribute after click "Añadir archivo adjunto" link', :js do
          visit new_admin_organization_path

          expect(page).not_to have_selector "input[type=file]"
          click_link "Añadir archivo adjunto"
          expect(page).to have_selector "input[type=file]"
        end
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
        category = create(:category)
        visit new_admin_organization_path

        fill_in :organization_name, with: "organization name"
        select category.name, from: :organization_category_id
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        click_button "Guardar"

        expect(page).to have_content "Registro creado correctamente"
      end

      scenario 'Should create organization with data fields' do
        new_category = create(:category)
        create(:registered_lobby)
        visit new_admin_organization_path

        fill_in :organization_identifier, with: "New identifier"
        fill_in :organization_name, with: "New name"
        fill_in :organization_first_surname, with: "New first_surname"
        fill_in :organization_second_surname, with: "New second_surname"
        fill_in :organization_phones, with: "New phones"
        fill_in :organization_email, with: "new@email.com"
        select new_category.name, from: :organization_category_id
        fill_in :organization_web, with: "www.new_web.com"
        fill_in :organization_description, with: "New description"
        select "Generalitat Catalunya", from: :organization_registered_lobby_ids

        # mandatory user fields
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        click_button "Guardar"

        organization = Organization.where(name: "New name").first
        expect(page).to have_content "Registro creado correctamente"
        expect(organization.identifier).to eq "New identifier"
        expect(organization.name).to eq "New name"
        expect(organization.first_surname).to eq "New first_surname"
        expect(organization.second_surname).to eq "New second_surname"
        expect(organization.phones).to eq "New phones"
        expect(organization.email).to eq "new@email.com"
        expect(organization.category.name).to eq new_category.name
        expect(organization.web).to eq "www.new_web.com"
        expect(organization.description).to eq "New description"
        expect(organization.registered_lobbies.first.name).to eq "Generalitat Catalunya"
      end

      scenario 'Should create organization with address fields' do
        new_category = create(:category)
        visit new_admin_organization_path

        fill_in :organization_web, with: "www.new_web.com"
        fill_in :organization_address_type, with: "New address_type"
        fill_in :organization_address, with: "New address"
        fill_in :organization_number, with: "New number"
        fill_in :organization_gateway, with: "New gateway"
        fill_in :organization_stairs, with: "New stairs"
        fill_in :organization_floor, with: "New floor"
        fill_in :organization_door, with: "New door"
        fill_in :organization_postal_code, with: "New postal_code"
        fill_in :organization_town, with: "New town"
        fill_in :organization_province, with: "New province"
        fill_in :organization_description, with: "New description"
        # mandatory user fields
        fill_in :organization_name, with: "New name"
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        select new_category.name, from: :organization_category_id
        click_button "Guardar"

        organization = Organization.where(name: "New name").first
        expect(page).to have_content "Registro creado correctamente"
        expect(organization.web).to eq "www.new_web.com"
        expect(organization.address_type).to eq "New address_type"
        expect(organization.address).to eq "New address"
        expect(organization.number).to eq "New number"
        expect(organization.gateway).to eq "New gateway"
        expect(organization.stairs).to eq "New stairs"
        expect(organization.floor).to eq "New floor"
        expect(organization.door).to eq "New door"
        expect(organization.postal_code).to eq "New postal_code"
        expect(organization.town).to eq "New town"
        expect(organization.province).to eq "New province"
        expect(organization.description).to eq "New description"
      end

      scenario 'Should create organization with lobby fields' do
        new_category = create(:category)
        visit new_admin_organization_path

        fill_in :organization_fiscal_year, with: 2014
        select "Más de 50.000 euros", from: :organization_range_fund
        choose("organization_contract_true")
        choose("organization_subvention_true")
        # mandatory user fields
        fill_in :organization_name, with: "New name"
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        select new_category.name, from: :organization_category_id
        click_button "Guardar"

        organization = Organization.where(name: "New name").first
        expect(page).to have_content "Registro creado correctamente"
        expect(organization.fiscal_year).to eq 2014
        expect(organization.range_fund).to eq "range_4"
        expect(organization.contract).to eq true
        expect(organization.subvention).to eq true
      end

      scenario 'Should create organization with terms fields' do
        new_category = create(:category)
        visit new_admin_organization_path

        check "organization_certain_term"
        check "organization_code_of_conduct_term"
        check "organization_gift_term"
        check "organization_lobby_term"
        # mandatory user fields
        fill_in :organization_name, with: "New name"
        fill_in :organization_user_attributes_first_name, with: "user first name"
        fill_in :organization_user_attributes_last_name, with: "user last name"
        fill_in :organization_user_attributes_email, with: "user@email.com"
        fill_in :organization_user_attributes_password, with: "password"
        fill_in :organization_user_attributes_password_confirmation, with: "password"
        select new_category.name, from: :organization_category_id
        click_button "Guardar"

        organization = Organization.where(name: "New name").first
        expect(organization.certain_term).to eq true
        expect(organization.code_of_conduct_term).to eq true
        expect(organization.gift_term).to eq true
        expect(organization.lobby_term).to eq true
      end

      scenario 'Should show registred lobbies' do
        create(:category)
        organization = create(:organization)
        create(:registered_lobby, name: "European Country")
        create(:registered_lobby, name: "Local Lobby")
        visit new_admin_organization_path
        organization.reload
        expect(page).to have_content "European Country"
        expect(page).to have_content "Local Lobby"
      end

      describe "Nested fields" do

        describe "Legal Representant" do

          scenario 'Try create organization with invalid legal representant and display error', :js do
            category = create(:category)
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            select category.name, from: :organization_category_id
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"
            click_on "Añadir representante legal"
            fill_in :organization_legal_representant_attributes_identifier, with: "43138883z"
            fill_in :organization_legal_representant_attributes_name, with: "Name"
            fill_in :organization_legal_representant_attributes_first_surname, with: "First name"
            fill_in :organization_legal_representant_attributes_email, with: nil
            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
          end

          scenario 'Create organization with valid legal representant', :js do
            category = create(:category)
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            select category.name, from: :organization_category_id
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"
            click_on "Añadir representante legal"
            fill_in :organization_legal_representant_attributes_identifier, with: "43138883z"
            fill_in :organization_legal_representant_attributes_name, with: "43138883z"
            fill_in :organization_legal_representant_attributes_first_surname, with: "43138883z"
            fill_in :organization_legal_representant_attributes_email, with: "valid@email.com"
            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Only add one legal representant', :js do
            visit new_admin_organization_path

            click_on "Añadir representante legal"

            expect(page).to have_selector("#legal_representant_link", visible: false)
          end

          scenario 'Display remove button after add one legal representant', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_legal_representant .remove_fields"
            click_on "Añadir representante legal"

            expect(page).to have_selector "#new_legal_representant .remove_fields"
          end

        end

        describe "Represented Entities" do

          scenario 'Try create organization with invalid respresented entities and display error', :js do
            category = create(:category)
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            select category.name, from: :organization_category_id
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Entidades/personas a las que se representa"

            within "#new_represented_entity" do
              fill_in "DNI/NIF/NIE/Pasaporte", with: "43138883z"
              fill_in "Nombre o razón social", with: "Name"
              fill_in "Ejercicio anual", with: 2017
              fill_in "Fecha de inicio de la representación", with: nil
            end

            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
          end

          scenario 'Create organization with valid represented entities', :js do
            category = create(:category)
            visit new_admin_organization_path

            fill_in :organization_name, with: "organization name"
            select category.name, from: :organization_category_id
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_on "Añadir Entidades/personas a las que se representa"

            within "#new_represented_entity" do
              fill_in "DNI/NIF/NIE/Pasaporte", with: "43138883z"
              fill_in "Nombre o razón social", with: "Name"
              fill_in "Ejercicio anual", with: 2017
              fill_in "Fecha de inicio de la representación", with: Date.current
            end

            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Can adding more than one represented entity' do
            visit new_admin_organization_path

            click_on "Añadir Entidades/personas a las que se representa"

            expect(page).to have_content "Añadir Entidades/personas a las que se representa"
          end

          scenario 'Display remove button after add represented entity', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_represented_entity .remove_fields"
            click_on "Añadir Entidades/personas a las que se representa"

            expect(page).to have_selector "#new_represented_entity .remove_fields"
          end

          scenario 'Display remove button after add more than one represented entity', :js do
            visit new_admin_organization_path

            expect(page).not_to have_selector "#new_represented_entity .remove_fields"
            click_on "Añadir Entidades/personas a las que se representa"
            click_on "Añadir Entidades/personas a las que se representa"

            expect(page).to have_selector "#new_represented_entity .remove_fields", count: 2
          end
        end

        describe "Documents" do
          scenario 'Create organization with valid document', :js do
            category = create(:category)
            visit new_admin_organization_path
            fill_in :organization_name, with: "organization name"
            select category.name, from: :organization_category_id
            fill_in :organization_user_attributes_first_name, with: "user first name"
            fill_in :organization_user_attributes_last_name, with: "user last name"
            fill_in :organization_user_attributes_email, with: "user@email.com"
            fill_in :organization_user_attributes_password, with: "password"
            fill_in :organization_user_attributes_password_confirmation, with: "password"

            click_link "Añadir archivo adjunto"
            within "#nested-attachments" do
              attach_file find("input[type='file']")[:id], "spec/fixtures/dummy.pdf"
            end
            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
            expect(Organization.last.attachments.count).to eq(1)
          end
        end
      end

      scenario "Shouldn't show invalidate button" do
        visit new_admin_organization_path

        expect(page).not_to have_content "Invalidate"
      end

    end

    describe "Edit" do

      describe "Agents" do

        scenario 'Should display agents information for persisted organization records' do
          organization = create(:organization)
          agent = create(:agent, organization: organization)
          visit edit_admin_organization_path(organization)

          expect(page).to have_link "Añadir Agentes", href: new_admin_organization_agent_path(organization)
          expect(page).to have_content agent.fullname
        end

        scenario "Should navigate to admin organization agents when user click on 'Añadir Agentes' link" do
          organization = create(:organization)
          create(:agent, organization: organization)
          visit edit_admin_organization_path(organization)

          click_link "Añadir Agentes"
          expect(page).to have_content "Nuevo agente"
        end

      end

      scenario "Should show invalidate button on valid organization" do
        organization = create(:organization)
        visit edit_admin_organization_path(organization)

        expect(find_link(I18n.t('organizations.validate'))[:disabled]).to eq "disabled"
        expect(find_link(I18n.t('organizations.invalidate'))[:disabled]).not_to eq "disabled"
      end

      scenario "User incorrect invalidate tests", :js do
        organization = create(:organization)
        visit edit_admin_organization_path(organization)

        click_link I18n.t('organizations.invalidate')
        click_button "Guardar"

        expect(page).to have_content I18n.translate('event.cancel_reasons_needed')
      end

      scenario "Should show validate buttons on invalid organization" do
        organization = create(:organization)
        organization.update(invalidated_reasons: 'test')
        organization.update(invalidated_at: Time.zone.today)

        visit edit_admin_organization_path(organization)

        expect(find_link(I18n.t('organizations.validate'))[:disabled]).not_to eq "disabled"
        expect(find_link(I18n.t('organizations.invalidate'))[:disabled]).to eq "disabled"
      end

      scenario 'Visit edit admin organization page and remove mandatory fields from organization should display error' do
        organization = create(:organization)
        visit edit_admin_organization_path(organization)

        fill_in :organization_name, with: ""
        click_button "Guardar"

        expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
      end

      scenario 'Should update data organization fields' do
        new_category = create(:category)
        organization = create(:organization)
        new_registered_lobby = create(:registered_lobby, name: "New Registered Lobby")
        visit edit_admin_organization_path(organization)

        fill_in :organization_identifier, with: "New identifier"
        fill_in :organization_name, with: "New name"
        fill_in :organization_first_surname, with: "New first_surname"
        fill_in :organization_second_surname, with: "New second_surname"
        fill_in :organization_phones, with: "New phones"
        fill_in :organization_email, with: "new@email.com"
        select new_category.name, from: :organization_category_id
        fill_in :organization_web, with: "www.new_web.com"
        fill_in :organization_description, with: "New description"
        page.select new_registered_lobby.name, from: :organization_registered_lobby_ids

        click_button "Guardar"

        organization.reload

        expect(page).to have_content "Registro actualizado correctamente"
        expect(organization.identifier).to eq "New identifier"
        expect(organization.name).to eq "New name"
        expect(organization.first_surname).to eq "New first_surname"
        expect(organization.second_surname).to eq "New second_surname"
        expect(organization.phones).to eq "New phones"
        expect(organization.email).to eq "new@email.com"
        expect(organization.category.name).to eq new_category.name
        expect(organization.web).to eq "www.new_web.com"
        expect(organization.description).to eq "New description"
        expect(organization.registered_lobbies.first.name).to eq "New Registered Lobby"
      end

      scenario 'Should update address organization fields' do
        organization = create(:organization)
        visit edit_admin_organization_path(organization)

        fill_in :organization_web, with: "www.new_web.com"
        fill_in :organization_address_type, with: "New address_type"
        fill_in :organization_address, with: "New address"
        fill_in :organization_number, with: "New number"
        fill_in :organization_gateway, with: "New gateway"
        fill_in :organization_stairs, with: "New stairs"
        fill_in :organization_floor, with: "New floor"
        fill_in :organization_door, with: "New door"
        fill_in :organization_postal_code, with: "New postal_code"
        fill_in :organization_town, with: "New town"
        fill_in :organization_province, with: "New province"
        fill_in :organization_description, with: "New description"
        click_button "Guardar"

        organization.reload
        expect(page).to have_content "Registro actualizado correctamente"
        expect(organization.web).to eq "www.new_web.com"
        expect(organization.address_type).to eq "New address_type"
        expect(organization.address).to eq "New address"
        expect(organization.number).to eq "New number"
        expect(organization.gateway).to eq "New gateway"
        expect(organization.stairs).to eq "New stairs"
        expect(organization.floor).to eq "New floor"
        expect(organization.door).to eq "New door"
        expect(organization.postal_code).to eq "New postal_code"
        expect(organization.town).to eq "New town"
        expect(organization.province).to eq "New province"
        expect(organization.description).to eq "New description"
      end

      scenario 'Should update lobby organization fields' do
        organization = create(:organization, subvention: false, contract: false)
        visit edit_admin_organization_path(organization)

        fill_in :organization_fiscal_year, with: 2014
        select "Más de 50.000 euros", from: :organization_range_fund
        choose("organization_contract_true")
        choose("organization_subvention_true")
        click_button "Guardar"

        organization.reload
        expect(page).to have_content "Registro actualizado correctamente"
        expect(organization.fiscal_year).to eq 2014
        expect(organization.range_fund).to eq "range_4"
        expect(organization.contract).to eq true
        expect(organization.subvention).to eq true
      end

      scenario 'Should update terms organization fields', :js do
        organization = create(:organization, certain_term: false, code_of_conduct_term: false, gift_term: false, lobby_term: false)
        visit edit_admin_organization_path(organization)

        check "organization_certain_term"
        check "organization_code_of_conduct_term"
        check "organization_gift_term"
        check "organization_lobby_term"
        click_button "Guardar"

        organization.reload
        expect(organization.certain_term).to eq true
        expect(organization.code_of_conduct_term).to eq true
        expect(organization.gift_term).to eq true
        expect(organization.lobby_term).to eq true
      end

      describe "Nested fields" do

        describe "Legal Representant" do

          scenario 'Try update organization with invalid legal representant and display error' do
            organization = create(:organization)
            create(:legal_representant, organization: organization)
            visit edit_admin_organization_path(organization)

            fill_in :organization_legal_representant_attributes_email, with: nil
            fill_in :organization_legal_representant_attributes_identifier, with: nil
            fill_in :organization_legal_representant_attributes_name, with: nil
            fill_in :organization_legal_representant_attributes_first_surname, with: nil
            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
            expect(page).to have_content "4 errores impidieron guardar este Organization"
            expect(page).to have_content "Representante Legal: email no puede estar en blanco"
            expect(page).to have_content "Representante Legal: Identificador no puede estar en blanco"
            expect(page).to have_content "Representante Legal: Nombre no puede estar en blanco"
            expect(page).to have_content "Representante Legal: Apellido no puede estar en blanco"
          end

          scenario 'Update organization with valid legal representant' do
            organization = create(:organization)
            legal_representant = create(:legal_representant, organization: organization)
            visit edit_admin_organization_path(organization)

            # mandatory fields
            fill_in :organization_legal_representant_attributes_identifier, with: "new identifier"
            fill_in :organization_legal_representant_attributes_name, with: "new name"
            fill_in :organization_legal_representant_attributes_first_surname, with: "new first surname"
            fill_in :organization_legal_representant_attributes_email, with: "new@email.com"
            # opional fields
            fill_in :organization_legal_representant_attributes_second_surname, with: "new second surname"
            fill_in :organization_legal_representant_attributes_phones, with: "971466655"
            click_button "Guardar"

            legal_representant.reload
            expect(page).to have_content "Registro actualizado correctamente"
            expect(legal_representant.identifier).to eq "new identifier"
            expect(legal_representant.name).to eq "new name"
            expect(legal_representant.first_surname).to eq "new first surname"
            expect(legal_representant.second_surname).to eq "new second surname"
            expect(legal_representant.email).to eq "new@email.com"
            expect(legal_representant.phones).to eq "971466655"
          end

          scenario 'Update to blank legal representants fields', :js do
            organization = create(:organization)
            create(:legal_representant, organization: organization)
            visit edit_admin_organization_path(organization)

            within "#nested-legal-representant-wrapper" do
              click_on "Eliminar"
            end
            click_button "Guardar"

            organization.reload
            expect(page).to have_content "Registro actualizado correctamente"
            expect(organization.legal_representant).to eq nil
          end

        end

        describe "Contact Person (User)" do

          scenario 'Try update organization with invalid user and display error' do
            organization = create(:organization)
            visit edit_admin_organization_path(organization)

            fill_in :organization_user_attributes_email, with: nil
            fill_in :organization_user_attributes_first_name, with: nil
            fill_in :organization_user_attributes_last_name, with: nil
            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
            expect(page).to have_content "3 errores impidieron guardar este Organization"
            expect(page).to have_content "Persona física de contacto: email"
            expect(page).to have_content "Persona física de contacto: Nombre"
            expect(page).to have_content "Persona física de contacto: Apellidos"
          end

          scenario 'Update organization with valid user' do
            organization = create(:organization)
            visit edit_admin_organization_path(organization)

            # mandatory fields
            fill_in :organization_user_attributes_first_name, with: "new first name"
            fill_in :organization_user_attributes_last_name, with: "new last name"
            fill_in :organization_user_attributes_email, with: "new@email.com"
            # opional fields
            fill_in :organization_user_attributes_phones, with: "971466655"
            click_button "Guardar"

            organization.reload
            expect(page).to have_content "Registro actualizado correctamente"
            expect(organization.user.first_name).to eq "new first name"
            expect(organization.user.last_name).to eq "new last name"
            expect(organization.user.email).to eq "new@email.com"
            expect(organization.user.phones).to eq "971466655"
          end

        end

        describe "Represented Entities" do

          scenario 'Try update organization with invalid represented_entity and display error' do
            organization = create(:organization)
            create(:represented_entity, organization: organization)
            visit edit_admin_organization_path(organization)

            fill_in :organization_represented_entities_attributes_0_name, with: nil
            fill_in :organization_represented_entities_attributes_0_identifier, with: nil
            fill_in :organization_represented_entities_attributes_0_fiscal_year, with: nil
            fill_in :organization_represented_entities_attributes_0_from, with: nil

            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
            expect(page).to have_content "3 errores impidieron guardar este Organization"
            expect(page).to have_content "Entidad Representada: Identificador no puede estar en blanco"
            expect(page).to have_content "Entidad Representada: Nombre no puede estar en blanco"
            expect(page).to have_content "Entidad Representada: Fecha de inicio no puede estar en blanco"
          end

          scenario 'Update organization with valid represented entity' do
            organization = create(:organization)
            represented_entity = create(:represented_entity, organization: organization, subvention: false, contract: false)
            new_date = Time.zone.today
            visit edit_admin_organization_path(organization)

            # mandatory fields
            fill_in :organization_represented_entities_attributes_0_name, with: "New name"
            fill_in :organization_represented_entities_attributes_0_identifier, with: "New identifier"
            fill_in :organization_represented_entities_attributes_0_fiscal_year, with: 2014
            fill_in :organization_represented_entities_attributes_0_from, with: new_date
            # optional fields
            fill_in :organization_represented_entities_attributes_0_first_surname, with: "new first surname"
            fill_in :organization_represented_entities_attributes_0_second_surname, with: "new second surname"
            select "Más de 50.000 euros", from: :organization_represented_entities_attributes_0_range_fund
            choose("organization_represented_entities_attributes_0_subvention_true")
            choose("organization_represented_entities_attributes_0_contract_true")
            click_button "Guardar"

            represented_entity.reload
            expect(page).to have_content "Registro actualizado correctamente"
            expect(represented_entity.name).to eq "New name"
            expect(represented_entity.identifier).to eq "New identifier"
            expect(represented_entity.fiscal_year).to eq 2014
            expect(represented_entity.from).to eq new_date
            expect(represented_entity.first_surname).to eq "new first surname"
            expect(represented_entity.second_surname).to eq "new second surname"
            expect(represented_entity.range_fund).to eq "range_4"
            expect(represented_entity.subvention).to eq true
            expect(represented_entity.contract).to eq true
          end

          scenario 'Update to blank represented entity fields', :js do
            organization = create(:organization)
            create(:represented_entity, organization: organization)
            visit edit_admin_organization_path(organization)

            within "#nested-represented-entities" do
              click_on "Eliminar"
            end
            click_button "Guardar"

            organization.reload
            expect(page).to have_content "Registro actualizado correctamente"
            expect(organization.represented_entities).to eq []
          end

        end

        describe "Documents" do
          scenario 'Should display add attachment link' do
            organization = create(:organization)
            visit edit_admin_organization_path(organization)

            expect(page).to have_content "Archivos adjuntos"
            expect(page).to have_link "Añadir archivo adjunto"
          end

          scenario 'Should add new attachment file attribute after click "Añadir archivo adjunto" link', :js do
            organization = create(:organization)
            visit edit_admin_organization_path(organization)

            expect(page).not_to have_selector "input[type=file]"
            click_link "Añadir archivo adjunto"
            expect(page).to have_selector "input[type=file]"
          end

          scenario 'Should remove destroyed attachments', :js do
            organization = create(:organization)
            create(:attachment, organization: organization)
            visit edit_admin_organization_path(organization)

            click_link "Eliminar archivo adjunto"
            click_on "Guardar"
            visit edit_admin_organization_path(organization)

            expect(page).not_to have_link "Eliminar archivo adjunto"
          end

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
          organization.update(invalidated_reasons: 'test')
          organization.update(invalidated_at: Time.zone.today)

          visit organization_path(organization)

          expect(page).to have_content "Estado Inhabilitado"
        end
      end

      scenario "Should display canceled organization and display agent info" do
        organization = create(:organization, canceled_at: Date.current)
        agent = create(:agent, organization: organization)

        visit organization_path(organization)

        expect(page).to have_content organization.name
        expect(page).to have_content agent.name
        expect(page).to have_content agent.first_surname
        expect(page).to have_content agent.second_surname
      end

      scenario "Should display invalidate organization and displday agent info" do
        organization = create(:organization)
        agent = create(:agent, organization: organization)
        organization.update(invalidated_reasons: 'test')
        organization.update(invalidated_at: Time.zone.today)

        visit organization_path(organization)

        expect(page).to have_content organization.name
        expect(page).to have_content agent.name
        expect(page).to have_content agent.first_surname
        expect(page).to have_content agent.second_surname
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

      within "#admin_menu" do
        expect(page).not_to have_content "Lobbies"
      end
    end

  end

  describe "Lobby" do

    background do
      @lobby = create(:user, :lobby)
      create(:organization, user: @lobby)
      signin(@lobby.email, @lobby.password)

      @interest = create(:interest)
    end

    scenario 'Visit lobby backend page and not display organization button on sidebar' do
      visit admin_path

      within "#admin_menu" do
        expect(page).not_to have_content "Lobbies"
      end
    end

    scenario 'Has edit organization buttons on sidebar' do
      visit admin_path

      expect(page).to have_content I18n.t("backend.edit_agents")
      expect(page).to have_content I18n.t("backend.add_interests")
      expect(page).to have_content I18n.t("backend.show_company")
    end

    scenario 'Can add interests' do
      visit admin_path

      click_link I18n.t("backend.add_interests")

      expect(page).to have_content I18n.t("backend.interest.title_fieldset")

      check "organization_interest_ids_#{@interest.id}"
      click_button 'Guardar'

      expect(current_path).to eq(admin_organization_path(id: @lobby.organization_id))
      expect(page).to have_field("interest_#{@interest.id}", checked: true, disabled: true)
    end

    scenario 'Show organization details' do
      visit admin_path

      click_link I18n.t("backend.show_company")

      expect(page).to have_content I18n.t('backend.reference.title_fieldset')
      expect(page).to have_content I18n.t('backend.reference.title')
      expect(page).to have_content @lobby.email
    end

  end

  describe "Edit (remote)" do

    background do
      user_admin = create(:user, :lobby)
      signin(user_admin.email, user_admin.password)
    end

    scenario 'Should show page title' do
      visit admin_path

      click_link I18n.t 'backend.edit_organization'
      expect(page).to have_content I18n.t 'organizations.edit.title'
    end

  end

  describe "Destroy (remote)" do

    background do
      user_admin = create(:user, :lobby)
      signin(user_admin.email, user_admin.password)
    end

    scenario 'Should show page title' do
      visit admin_path

      click_link I18n.t 'backend.delete_organization'
      expect(page).to have_content I18n.t 'organizations.delete.title'
    end

  end

end
