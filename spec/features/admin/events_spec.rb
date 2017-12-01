feature 'Events' do

  describe 'user manager', type: :feature do

    background do
      user_manager = create(:user, :user)
      position = create(:position)
      user_manager.manages.create(holder_id: position.holder_id)
      signin(user_manager.email, user_manager.password)
    end

    scenario 'visit the events index page' do
      visit events_path

      expect(page).to have_content I18n.t 'backend.events'
    end

    scenario 'visit create event form' do
      visit new_event_path

      expect(page).to have_selector('#new_event')
      expect(page).not_to have_selector('#edit_event')
    end
  end

  describe 'user admin' do

    background do
      user_admin = create(:user, :admin)
      position = create(:position)
      user_admin.manages.create(holder_id: position.holder_id)
      signin(user_admin.email, user_admin.password)
    end

    scenario 'visit show event page' do
      event = create(:event, title: 'New event from Capybara')
      visit events_path

      click_link event.title

      expect(page).to have_content event.title
    end

    scenario 'edit event and modify title' do
      event = create(:event, title: 'Test event')
      visit edit_event_path(event)

      fill_in :event_title, with: 'New event modified from Capybara'
      click_button I18n.t 'backend.save'

      expect(page).to have_content 'New event modified from Capybara'
    end

    scenario 'visit search by title' do
      event = create(:event, title: 'New event from Capybara')
      visit events_path

      fill_in :search_title, with: 'Capybara'
      click_button I18n.t('backend.search.button')

      expect(page).to have_content event.title
    end

    scenario 'visit search by person' do
      event = create(:event, title: 'New event from Capybara')
      name = event.position.holder.first_name
      visit events_path

      fill_in :search_person, with: name
      click_button I18n.t('backend.search.button')

      expect(page).to have_content event.title
    end

    scenario 'visit non results search page' do
      create(:event, title: 'New not found event')
      visit events_path

      fill_in :search_title, with: 'Search keywords'
      click_button I18n.t('backend.search.button')

      expect(page).to have_content "No se han encontrado eventos"
    end

    describe "Create" do

      scenario 'visit create event form' do
        visit new_event_path

        expect(page).to have_selector('#new_event')
        expect(page).not_to have_selector('#edit_event')
      end

      scenario 'Visit new admin event page and create event without mandatory fields and display error', :js do
        visit new_event_path

        click_button "Guardar"

        expect(page).to have_content "Este campo es obligatorio", count: 5
      end

      scenario 'Visit new admin event page and create organization with the minimum permitted fields' do
        new_position = create(:position)
        visit new_event_path

        fill_in :event_title, with: "Title"
        fill_in :event_location, with: "Location"
        fill_in :event_scheduled, with: DateTime.current
        select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
        choose :event_lobby_activity_true
        fill_in :event_published_at, with: Date.current
        click_button "Guardar"

        expect(page).to have_content "Registro creado correctamente"
      end

      scenario 'Should create organization with all fields without nesteds' do
        new_position = create(:position)
        visit new_event_path

        fill_in :event_title, with: "Title"
        fill_in :event_location, with: "Location"
        fill_in :event_description, with: "Description"
        fill_in :event_scheduled, with: Date.current
        select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
        choose :event_lobby_activity_true
        fill_in :event_published_at, with: Date.current
        click_button "Guardar"

        event = Event.where(title: "Title").first
        expect(page).to have_content "Registro creado correctamente"
        expect(event.title).to eq "Title"
        expect(event.location).to eq "Location"
        expect(event.description).to eq "Description"
        expect(event.scheduled).to eq Date.current
        expect(event.position).to eq new_position
        expect(event.lobby_activity).to eq true
        expect(event.published_at).to eq Date.current
      end

      describe "Nested fields" do

        describe "Participants" do

          scenario 'Create organization with participant', :js do
            new_position = create(:position)
            visit new_event_path

            #Mandatory fields
            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: DateTime.current
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_true
            fill_in :event_published_at, with: Date.current
            #Participant fields
            find('.add-participant').click

            within "#participants" do
              find("option[value='1']").select_option
            end
            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Can adding more than one participants', :js do
            visit new_event_path

            find('.add-participant').click

            expect(page).to have_selector('.add-participant', count: 1)
          end

          scenario 'Display remove button after add participants', :js do
            visit new_event_path

            expect(page).not_to have_selector "#participants .remove_fields"
            find('.add-participant').click

            expect(page).to have_selector "#participants .remove_fields"
          end

          scenario 'Display remove button after add more than one represented entity', :js do
            visit new_event_path

            expect(page).not_to have_selector "#participants .remove_fields"
            find('.add-participant').click
            find('.add-participant').click

            expect(page).to have_selector "#participants .remove_fields", count: 2
          end

        end

        describe "Attendees" do

          scenario 'Create organization with invalid attendee', :js do
            new_position = create(:position)
            visit new_event_path

            #Mandatory fields
            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: DateTime.current
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_true
            fill_in :event_published_at, with: Date.current
            #Attendees fields
            find('.add-attendee').click
            find(".attendee-name").set("Name")
            click_button "Guardar"

            expect(page).to have_content "Por favor corrija los siguientes errores antes de continuar"
            expect(page).to have_content "2 errores impidieron guardar este evento"
            expect(page).to have_content "Asistente: Cargo no puede estar en blanco"
            expect(page).to have_content "Asistente: Organización no puede estar en blanco"
          end

          scenario 'Create organization with valid attendee', :js do
            new_position = create(:position)
            visit new_event_path

            #Mandatory fields
            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: DateTime.current
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_true
            fill_in :event_published_at, with: Date.current
            #Participant fields
            find('.add-attendee').click
            find(".attendee-name").set("Name")
            find(".attendee-position").set("Position")
            find(".attendee-company").set("Company")
            click_button "Guardar"

            expect(page).to have_content "Registro creado correctamente"
          end

          scenario 'Can adding more than one attendees', :js do
            visit new_event_path

            find('.add-attendee').click

            expect(page).to have_selector('.add-attendee', count: 1)
          end

          scenario 'Display remove button after add attendees', :js do
            visit new_event_path

            expect(page).not_to have_selector "#attendees .remove_fields"
            find('.add-attendee').click

            expect(page).to have_selector "#attendees .remove_fields"
          end

          scenario 'Display remove button after add more than one represented entity', :js do
            visit new_event_path

            expect(page).not_to have_selector "#attendees .remove_fields"
            find('.add-attendee').click
            find('.add-attendee').click

            expect(page).to have_selector "#attendees .remove_fields", count: 2
          end

        end

        describe "Attachments" do

          scenario 'Can adding more than one attachments', :js do
            visit new_event_path

            find('.add-attachment').click

            expect(page).to have_selector('.add-attachment', count: 1)
          end

          scenario 'Display remove button after add attachments', :js do
            visit new_event_path

            expect(page).not_to have_selector "#attachments .remove_fields"
            find('.add-attachment').click

            expect(page).to have_selector "#attachments .remove_fields"
          end

          scenario 'Display remove button after add more than one represented entity', :js do
            visit new_event_path

            expect(page).not_to have_selector "#attachments .remove_fields"
            find('.add-attachment').click
            find('.add-attachment').click

            expect(page).to have_selector "#attachments .remove_fields", count: 2
          end

        end

      end

      describe "Lobby activity" do

        scenario 'When check lobby activity true display organization_name', :js do
          visit new_event_path
          expect(page).to have_selector("#event_organization_name", visible: false)

          choose :event_lobby_activity_true

          expect(page).to have_selector("#event_organization_name", visible: true)
        end

        scenario 'When fill organization_name display new fields', :js do
          organization = create(:organization)
          visit new_event_path
          choose :event_lobby_activity_true

          choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

          expect(page).to have_selector("#category-block", visible: true)
          expect(page).to have_selector("#re-block", visible: true)
          expect(page).to have_selector("#agents-block", visible: true)
        end

        scenario 'When select organization display category', :js do
          organization = create(:organization)
          visit new_event_path
          choose :event_lobby_activity_true

          choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

          within "#category-block" do
            expect(page).to have_content organization.category.name
          end
        end

        describe "Represented entity" do

          scenario 'When select organization without represented_entity display organization on represented_entity selector', :js do
            organization = create(:organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within "#re-block" do
              expect(page).to have_selector("option[value='#{organization.name}']")
            end
          end

          scenario 'When select organization with represented_entity display represented_entity on represented_entity selector', :js do
            organization = create(:organization)
            represented_entity = create(:represented_entity, organization: organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within "#re-block" do
              expect(page).to have_selector("option[value='#{represented_entity.name}']")
            end
          end

        end

        describe "Agents" do

          scenario 'When select organization without agents display no_result_text on agents selector', :js do
            organization = create(:organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within "#agents-block" do
              expect(page).to have_selector("option[value='No hay agentes disponibles.']")
            end
          end

          scenario 'When select organization with agents display agent on agents selector', :js do
            organization = create(:organization)
            agent = create(:agent, organization: organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within "#agents-block" do
              expect(page).to have_selector("option[value='#{agent.name}']")
            end
          end

        end

      end

    end

  end

  describe 'Organization user' do
    background do
      organization_user = create(:user, :lobby)
      @position = create(:position)
      organization_user.manages.create(holder_id: @position.holder_id)
      signin(organization_user.email, organization_user.password)
    end

    scenario 'visit index event page' do
      event = create(:event, title: 'New event for lobbies', position: @position)
      visit events_path

      expect(page).to have_content event.title
    end

    scenario 'create new event', :js do
      event = create(:event, title: 'Event not for lobbies')
      visit events_path

      click_link I18n.t('backend.new_event')

      expect(page).to have_content I18n.t('backend.new_event')

      fill_in :event_title, with: 'New event for a lobby'
      fill_in :event_scheduled, with: '02/11/2017 06:30'
      fill_in :event_location, with: 'New location'
      choose :event_lobby_activity_true
      select "#{@position.holder.full_name_comma} - #{@position.title}", from: :event_position_id
      fill_in :event_published_at, with: '02/11/2017 06:30'

      click_button I18n.t('backend.save')

      expect(page).to have_content 'New event for a lobby'
      expect(page).to_not have_content event.title
    end

  end
end

def choose_autocomplete(field, options = {})
  page.execute_script %Q{ $('##{field}').trigger('focus'); }
  find("#event_organization_name").native.send_key(options[:with])
  sleep 1
  page.execute_script %Q{ $('li.ui-menu-item:contains("#{options[:select]}")').trigger("mouseenter").trigger("click"); }
end
