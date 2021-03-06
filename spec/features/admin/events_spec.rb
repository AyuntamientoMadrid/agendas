feature 'Events' do
  describe 'user manager', type: :feature do

    background do
      @organization = create(:organization)
      @user_manager = create(:user, :user, organization: @organization)
      @position = create(:position)
      @agent = create(:agent, organization: @organization)
      @user_manager.manages.create(holder_id: @position.holder_id)
      login_as @user_manager
    end

    describe "index" do

      scenario 'visit the events index page' do
        visit events_path(utf8: "✓", search_title: "", search_person: "",
                          status: ["requested", "declined"], lobby_activity: "1",
                          controller: "events", action: "index")
        expect(page).to have_content "Eventos"
        expect(page).to have_content I18n.t 'backend.event_tray'
      end

      scenario 'The liks from the menu should filter properly' do
        event1 = create(:event, position: @position,  title: '1 requested with lobby', lobby_activity: true)
        event2 = create(:event, position: @position,  title: '2 accepted with lobby', lobby_activity: true)
        event3 = create(:event, position: @position,  title: '3 done with lobby', lobby_activity: true)
        event4 = create(:event, position: @position,  title: '4 canceled with lobby', lobby_activity: true)
        event5 = create(:event, position: @position,  title: '5 declined with lobby', lobby_activity: true)
        event6 = create(:event, position: @position,  title: '6 requested')
        event7 = create(:event, position: @position,  title: '7 accepted')
        event8 = create(:event, position: @position,  title: '8 done')
        event9 = create(:event, position: @position,  title: '9 canceled')
        event10 = create(:event, position: @position,  title: '10 declined')

        event1.update(status: :requested)
        event2.update(status: :accepted)
        event3.update(status: :done)
        event4.update(status: :canceled)
        event5.update(status: :declined)
        event6.update(status: :requested)
        event7.update(status: :accepted)
        event8.update(status: :done)
        event9.update(status: :canceled)
        event10.update(status: :declined)

        visit events_path(utf8: "✓", search_title: "", search_person: "",
                          status: ["requested", "declined"], lobby_activity: "1",
                          controller: "events", action: "index" )

        click_link "Eventos"
        expect(find_link(I18n.t("backend.event_tray")).first(:xpath, ".//..")[:class]).not_to eq "active"
        expect(find_link("Eventos").first(:xpath, ".//..")[:class]).to eq "active"

        [event2, event3, event4, event7, event8, event9].each do |evnt|
          expect(page).to have_content evnt.title
        end
        [event1, event5, event6, event10].each do |evnt|
          expect(page).not_to have_content evnt.title
        end

        click_link I18n.t("backend.event_tray")
        expect(find_link(I18n.t("backend.event_tray")).first(:xpath, ".//..")[:class]).to eq "active"
        expect(find_link("Eventos").first(:xpath, ".//..")[:class]).not_to eq "active"

        [event1, event5].each do |evnt|
          expect(page).to have_content evnt.title
        end
        [event2, event3, event4, event6, event7, event8, event9, event10].each do |evnt|
          expect(page).not_to have_content evnt.title
        end

      end

      scenario 'Should allow to download all attachments from event attachments dropdown', :js do
        event = create(:event, position: @position)
        create(:attachment, event: event, title: "An amazing attachment title")
        create(:attachment, event: event, title: "Other title")
        visit events_path(utf8: "✓", search_title: "", search_person: "",
                          status: ["accepted", "done", "canceled"],
                          controller: "events", action: "index" )

        within "#event_#{event.id}" do
          find('.attachments-dropdown').click
        end

        expect(page).to have_link "An amazing attachment title"
        expect(page).to have_link "Other title"
      end

      scenario 'Should show events with status requested or declined' do
        event = create(:event, title: "Event 1", position: @position)
        event.status = 'requested'
        event.save
        event_two = create(:event, title: "Event 2", position: @position)
        event_two.status = 'accepted'
        event_two.save
        visit admin_path
        expect(page).to have_content('Event 1')
        expect(page).not_to have_content('Event 2')

      end

      describe 'CSV export link' do

        scenario 'Should download a CSV file UTF-8 encoded', :search do
          Event.reindex
          Sunspot.commit
          visit admin_path

          click_link "Exportar"

          header = page.response_headers['Content-Type']
          expect(header).to match 'text/csv; charset=utf-8'
        end

        scenario 'Should download CSV file containing own events', :search do
          event = create(:event, title: "Event 1", position: @position)
          event2 = create(:event, title: "Other position event")
          event.status = 'requested'
          event.save
          Event.reindex
          Sunspot.commit
          visit admin_path

          click_link "Exportar"

          expect(page).to have_content event.title
          expect(page).to have_content event.description
          expect(page).to have_content event.location
          expect(page).to have_content event.position.holder.full_name
          expect(page).to have_content I18n.l(event.scheduled, format: :short)
          expect(page).not_to have_content event2.title
        end
      end

    end

    describe "new" do

      scenario 'visit new event form' do
        visit new_event_path

        expect(page).to have_selector('#new_event')
        expect(page).not_to have_selector('#edit_event')
      end

      scenario 'visit new event form and render manager fields' do
        visit new_event_path

        expect(page).to have_selector('#event_title')
        expect(page).to have_selector('#event_location')
        expect(page).to have_selector('#event_description')
        expect(page).to have_selector('#event_manager_general_remarks')
        expect(page).to have_selector('#event_scheduled')
        expect(page).to have_selector('#event_position_id')
        expect(page).to have_selector('#event_lobby_activity_true')
        expect(page).to have_selector('#event_lobby_activity_false')
        expect(page).to have_selector('#event_published_at')
        expect(page).to have_selector('#event_lobby_contact_firstname')
        expect(page).to have_selector('#event_lobby_contact_lastname')
        expect(page).to have_selector('#event_lobby_contact_phone')
        expect(page).to have_selector('#event_lobby_contact_email')
      end

      scenario 'visit new event form and not render manager fields' do
        visit new_event_path

        expect(page).not_to have_content('Organización que solicita la reunión')
        expect(page).not_to have_selector('#event_general_remarks')
        expect(page).not_to have_selector('#event_lobby_scheduled')
      end

      scenario 'visit new event form and not render canceled option' do
        visit new_event_path

        expect(page).not_to have_content('Cancelar evento')
      end

      scenario 'visit new event form and not render rejected option' do
        visit new_event_path

        expect(page).not_to have_content('Rechazar evento')
      end

    end

    describe "edit" do

      scenario 'manager user can see on page the name of the organization' do
        event = create(:event, user: @user_manager, organization_name: "Organization name", position: @position)

        visit edit_event_path(event)

        expect(page).to have_content('Organización que solicita la reunión')
        expect(page).to have_css("#event_organization_name[disabled]")
      end

      scenario 'manager user can see on page lobby contact info' do
        event = create(:event, user: @user_manager, organization_name: "Organization name", position: @position, lobby_contact_firstname: "name",
                               lobby_contact_lastname: "lastname", lobby_contact_phone: "971466655", lobby_contact_email: "lobby@email.com")

        visit edit_event_path(event)

        within ".lobby-contact-info" do
          expect(page).to have_selector("input[value='name']")
          expect(page).to have_selector("input[value='lastname']")
          expect(page).to have_selector("input[value='971466655']")
          expect(page).to have_selector("input[value='lobby@email.com']")
        end
      end

      scenario 'visit edit event form and render lobby fields' do
        event = create(:event, user: @user_manager, organization_name: "Organization name", position: @position)

        visit edit_event_path(event)

        expect(page).to have_content('Organización que solicita la reunión')
        expect(page).to have_selector('#event_lobby_contact_firstname')
        expect(page).to have_selector('#event_lobby_contact_lastname')
        expect(page).to have_selector('#event_lobby_contact_phone')
        expect(page).to have_selector('#event_lobby_contact_email')
        expect(page).to have_selector('#event_title')
        expect(page).to have_selector('#event_location')
        expect(page).to have_selector('#event_description')
        expect(page).to have_selector('#event_manager_general_remarks')
        expect(page).to have_selector('#event_lobby_scheduled')
        expect(page).to have_selector('#event_general_remarks')
        expect(page).to have_selector('#event_scheduled')
        expect(page).to have_selector('#event_position_id')
        expect(page).to have_selector('#event_lobby_activity_true')
        expect(page).to have_selector('#event_lobby_activity_false')
        expect(page).to have_selector('#event_published_at')
      end

      scenario 'visit edit event form and render correct lobby values' do
        event = create(:event, user: @user_manager, organization_name: "Organization name", position: @position,
                               lobby_contact_firstname: 'name', lobby_contact_lastname: 'lastname',
                               lobby_contact_phone: '971466655', lobby_contact_email: 'lobby@email.com',
                               lobby_scheduled: 'Day 17', general_remarks: 'General remark')

        visit edit_event_path(event)

        expect(page).to have_selector("input[value='name']")
        expect(page).to have_selector("input[value='lastname']")
        expect(page).to have_selector("input[value='971466655']")
        expect(page).to have_selector("input[value='lobby@email.com']")
        expect(page).to have_content "Day 17"
        expect(page).to have_content("General remark")
      end

      scenario 'visit edit event form and render canceled option' do
        event = create(:event, organization: @organization, user: @user_manager,
                               lobby_contact_email: "user@email.com", lobby_activity: true,
                               position: @position)
        event.event_agents << create(:event_agent)

        event.status = 'requested'
        event.save

        visit edit_event_path(event)

        expect(find_link(I18n.t('backend.accept_event'))[:disabled]).not_to eq "disabled"
      end

      scenario 'visit edit event form and render rejected option' do
        event = create(:event, organization: @organization, user: @user_manager,
                               lobby_contact_email: "user@email.com", lobby_activity: true,
                               position: @position)
        event.event_agents << create(:event_agent)


        visit edit_event_path(event)

        expect(page).to have_content('Rechazar evento')
      end

      scenario 'edit event and redirect to accepted, canceled and done index', :js do
        event = create(:event, user: @user_manager, title: 'Test event', position: @position)
        visit edit_event_path(event)

        fill_in :event_title, with: 'New event modified from Capybara'
        click_button "Guardar"

        expect(page).to have_content 'New event modified from Capybara'
      end

      scenario 'edit event does not launch any email (:user)', :js do
        ActionMailer::Base.deliveries.clear
        event = create(:event, user: @user_manager, title: 'Test event', position: @position)
        visit edit_event_path(event)

        fill_in :event_title, with: 'New event modified from Capybara'
        click_button "Guardar"

        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

    end

  end

  describe 'user admin' do

    background do
      @user_admin = create(:user, :admin)
      @position = create(:position)
      @user_admin.manages.create(holder_id: @position.holder_id)
      login_as @user_admin
    end

    describe "show" do

      scenario 'visit show event page' do
        event = create(:event, user: @user_admin, title: 'New event from Capybara')
        attachment_public = create(:attachment, public: true, event: event)
        attachment_old = create(:attachment, event: event)
        attachment_private = create(:attachment, public: false, event: event)
        attachment_old.update_column(:public, nil)
        visit events_path

        click_link event.title

        expect(page).to have_content I18n.t("status.#{event.status}")
        expect(page).to have_content event.position.holder.full_name
        expect(page).to have_content event.title
        expect(page).to have_content event.location
        expect(page).to have_content I18n.l(event.scheduled, format: :short)
        expect(page).to have_content event.title
        expect(page).to have_content attachment_public.description
        expect(page).to have_content attachment_old.description
        expect(page).to have_content attachment_private.description
      end

      scenario 'visit show event page and dispaly status and reasons' do
        event = create(:event, user: @user_admin, title: 'New event from Capybara')
        event.update(status: :declined, declined_reasons: "declined reasons")

        visit event_path(event)

        expect(page).to have_content I18n.t("status.#{event.status}")
        expect(page).to have_content "Motivos"
        expect(page).to have_content "declined reasons"
      end

      scenario 'visit show event page and not dispaly reasons' do
        event = create(:event, user: @user_admin, title: 'New event from Capybara')

        visit event_path(event)

        expect(page).not_to have_content "Motivos"
      end

      scenario 'Display event lobby info' do
        event = create(:event, title: 'Lobby event')
        event.lobby_activity = true
        event.event_agents << create(:event_agent)
        event.event_represented_entities << create(:event_represented_entity)
        event.save!

        visit event_path(event)

        expect(page).to have_content event.organization.name
        expect(page).to have_content event.event_agents.first.name
        expect(page).to have_content event.event_represented_entities.first.name
      end

    end

    describe "edit" do

      scenario 'edit event and modify title', :js do
        event = create(:event, user: @user_admin, title: 'Test event')
        visit edit_event_path(event)

        fill_in :event_title, with: 'New event modified from Capybara'
        click_button "Guardar"

        expect(page).to have_content 'New event modified from Capybara'
      end

      scenario 'admin user can see on page the name of the organization' do
        event = create(:event, organization_name: "Organization name", position: @position)

        visit edit_event_path(event)

        expect(page).to have_content('Organización que solicita la reunión')
        expect(page).to have_css("#event_organization_name[disabled]")
      end

      scenario 'admin user can see on page lobby contact info' do
        event = create(:event, user: @user_admin, organization_name: "Organization name", lobby_contact_firstname: 'lobyname',
                               lobby_contact_lastname: 'lobbylastname', lobby_contact_phone: '600123123', lobby_contact_email: 'lobbyemail@email.com')

        visit edit_event_path(event)

        within ".lobby-contact-info" do
          expect(page).to have_selector("input[value='lobyname']")
          expect(page).to have_selector("input[value='lobbylastname']")
          expect(page).to have_selector("input[value='600123123']")
          expect(page).to have_selector("input[value='lobbyemail@email.com']")
        end
      end
    end

    describe "index" do

      scenario 'visit search by title' do
        event = create(:event, user: @user_admin, title: 'New event from Capybara')
        visit events_path

        fill_in :search_title, with: 'Capybara'
        click_button I18n.t('backend.search.button')

        expect(page).to have_content event.title
      end

      scenario 'visit search by person' do
        event = create(:event, user: @user_admin, title: 'New event from Capybara')
        name = event.position.holder.first_name
        visit events_path

        fill_in :search_person, with: name
        click_button I18n.t('backend.search.button')

        expect(page).to have_content event.title
      end

      scenario 'visit non results search page' do
        create(:event, user: @user_admin, title: 'New not found event')
        visit events_path

        fill_in :search_title, with: 'Search keywords'
        click_button I18n.t('backend.search.button')

        expect(page).to have_content "No se han encontrado eventos"
      end

      scenario 'search lobby activity' do
        event = create(:event, user: @user_admin, title: 'Test for check lobby_activity')
        event.lobby_activity = true
        event.event_agents << create(:event_agent)
        event.save!
        visit events_path

        check 'lobby_activity'
        click_button I18n.t('backend.search.button')

        expect(page).to have_content "Test for check lobby_activity"
      end

      scenario 'Should allow to download all attachments from event attachments dropdown', :js do
        event = create(:event)
        create(:attachment, event: event, title: "An amazing attachment title")
        create(:attachment, event: event, title: "Other title")
        visit events_path

        within "#event_#{event.id}" do
          find('.attachments-dropdown').click
        end

        expect(page).to have_link "An amazing attachment title"
        expect(page).to have_link "Other title"
      end

      describe 'CSV export link' do

        scenario 'Should download a CSV file UTF-8 encoded', :search do
          Event.reindex
          Sunspot.commit
          visit admin_path

          click_link "Exportar"

          header = page.response_headers['Content-Type']
          expect(header).to match 'text/csv; charset=utf-8'
        end

        scenario 'Should download CSV file containing all events', :search do
          event = create(:event)
          event2 = create(:event, title: "Other position event")
          event.status = 'requested'
          event.save
          Event.reindex
          Sunspot.commit
          visit admin_path

          click_link "Exportar"

          expect(page).to have_content event.title
          expect(page).to have_content event.description
          expect(page).to have_content event.location
          expect(page).to have_content event.position.holder.full_name
          expect(page).to have_content I18n.l(event.scheduled, format: :short)
          expect(page).to have_content event2.title
        end
      end
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

        expect(page).to have_content "Este campo es obligatorio", count: 2
      end

      scenario 'Visit new admin event page and create organization with the minimum permitted fields', :js do
        new_position = create(:position)
        visit new_event_path

        fill_in :event_title, with: "Title"
        fill_in :event_location, with: "Location"
        fill_in :event_scheduled, with: Time.zone.now
        select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
        choose :event_lobby_activity_false
        fill_in :event_published_at, with: Date.current
        click_button "Guardar"

        expect(page).to have_content "Registro creado correctamente"
      end

      scenario 'Should create organization with all fields without nesteds', :js do
        new_position = create(:position)
        visit new_event_path

        fill_in :event_title, with: "Title"
        fill_in :event_location, with: "Location"
        tinymce_fill_in(:event_description, "Description")
        fill_in :event_scheduled, with: Date.current
        select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
        choose :event_lobby_activity_false
        fill_in :event_published_at, with: Date.current
        click_button "Guardar"

        event = Event.where(title: "Title").first
        expect(page).to have_content "Registro creado correctamente"
        expect(event.title).to eq "Title"
        expect(event.location).to eq "Location"
        expect(event.description).to eq "<p>Description</p>"
        expect(event.scheduled).to eq Date.current
        expect(event.position).to eq new_position
        expect(event.lobby_activity).to eq false
        expect(event.published_at).to eq Date.current
      end

      describe "Nested fields" do

        describe "Participants" do

          scenario 'Create organization with participant', :js do
            new_position = create(:position)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_false
            fill_in :event_published_at, with: Date.current
            find('.add-participant').click
            within "#participants" do
              select "#{@position.holder.full_name_comma} - #{@position.title}"
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

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_false
            fill_in :event_published_at, with: Date.current
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

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_false
            fill_in :event_published_at, with: Date.current
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

          scenario 'Should save attachment when it has valid content type', :js do
            new_position = create(:position)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_false
            fill_in :event_published_at, with: Date.current
            find('.add-attachment').click
            find("input[type=file]").set("spec/fixtures/dummy.pdf")
            input_title = find(".attachment-title")
            fill_in input_title[:id], with: "Dummy pdf"
            click_on "Guardar"

            within "#event_#{Event.last.id}_attachments_dropdown", visible: false do
              expect(page).to have_link "Dummy pdf", visible: false
            end
          end

          scenario 'Should not save attachment when it has invalid content type', :js do
            new_position = create(:position)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            choose :event_lobby_activity_false
            fill_in :event_published_at, with: Date.current
            find('.add-attachment').click
            attachment = all(".attachment-file").first
            attach_file attachment[:id], "spec/fixtures/dummy.xml"
            input_title = find(".attachment-title")
            fill_in input_title[:id], with: "Dummy xml"
            click_on "Guardar"

            expect(page).to have_content "Archivo adjunto: El archivo proporcionado está en un formato no permitido. Los siguientes formatos de archivo son permitidos: pdf, jpg, png, txt, doc, docx, xls, xlsx, odt, odp, text, rtf."
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
          expect(page).to have_selector(".represented-entities-block", visible: true)
          expect(page).to have_selector(".agents-block", visible: true)
        end

        scenario 'We can search organization by identifier', :js do
          organization = create(:organization, identifier: "43138883z")
          visit new_event_path
          choose :event_lobby_activity_true

          choose_autocomplete :event_organization_name, with: "43138883z", select: organization.name

          expect(page).to have_selector("#category-block", visible: true)
          expect(page).to have_selector(".represented-entities-block", visible: true)
          expect(page).to have_selector(".agents-block", visible: true)
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

        scenario 'When check lobby_activity but fill invalid organization name', :js do
          new_position = create(:position)
          visit new_event_path

          choose :event_lobby_activity_true
          choose_autocomplete :event_organization_name, with: "invalid organization", select: "invalid organization"
          fill_in :event_title, with: "Title"
          fill_in :event_location, with: "Location"
          tinymce_fill_in(:event_description, "Description")
          fill_in :event_scheduled, with: Date.current
          select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
          fill_in :event_published_at, with: Date.current
          click_button "Guardar"

          expect(page).to have_content "No ha seleccionado una organización válida"
        end

        describe "Represented entity" do

          scenario 'When select organization without represented_entity display organization on represented_entity selector', :js do
            organization = create(:organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within ".represented-entities-block" do
              expect(page).to have_selector("option[value='#{organization.name}']")
            end
          end

          scenario 'When select organization with represented_entity display represented_entity on represented_entity selector', :js do
            organization = create(:organization)
            represented_entity = create(:represented_entity, organization: organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within ".represented-entities-block" do
              expect(page).to have_selector("option[value='#{represented_entity.name} #{represented_entity.first_surname} #{represented_entity.second_surname}']")
            end
          end

        end

        describe "Agents" do

          scenario 'When select organization without agents display no_result_text on agents selector', :js do
            organization = create(:organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within ".agents-block" do
              expect(page).to have_selector("option[value='No hay agentes disponibles.']")
            end
          end

          scenario 'When select organization with agents display agent on agents selector', :js do
            organization = create(:organization)
            agent = create(:agent, organization: organization)
            visit new_event_path
            choose :event_lobby_activity_true

            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            within ".agents-block" do
              expect(page).to have_selector("option[value='#{agent.name} #{agent.first_surname} #{agent.second_surname}']")
            end
          end

          scenario "When radio lobby activity is set to true, only can save selecting an agent", :js do
            new_position = create(:position)
            organization = create(:organization, name: "New oganization with agents")
            agent = create(:agent, organization: organization)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            fill_in :event_published_at, with: Date.current
            choose :event_lobby_activity_true
            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name
            within('#new_event_agent') do
              select "#{agent.name} #{agent.first_surname} #{agent.second_surname}"
            end
            click_button "Guardar"
            expect(page).to have_content "Registro creado correctamente"
          end

          scenario "When fill by js organization_name without agents display no_result_text on agents selector", :js do
            organization = create(:organization, name: "New oganization with agents", entity_type: :lobby)
            new_position = create(:position)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            fill_in :event_published_at, with: Date.current
            choose :event_lobby_activity_true
            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name
            sleep(0.5)
            click_button "Guardar"

            expect(page).to have_content I18n.translate('backend.event.event_agent_needed'), count: 1
          end

          scenario "When fill by js organization_name (Association) not display no_result_text on agents selector", :js do
            organization = create(:organization, name: "New association", entity_type: :association)
            new_position = create(:position)
            visit new_event_path

            fill_in :event_title, with: "Title"
            fill_in :event_location, with: "Location"
            fill_in :event_scheduled, with: Time.zone.now
            select "#{new_position.holder.full_name_comma} - #{new_position.title}", from: :event_position_id
            fill_in :event_published_at, with: Date.current
            choose :event_lobby_activity_true
            choose_autocomplete :event_organization_name, with: organization.name, select: organization.name

            click_button "Guardar"

            expect(page).to have_content I18n.translate('backend.event.event_agent_needed'), count: 0
          end
        end
      end
    end
  end

  describe 'organization user' do
    background do
      @organization = create(:organization)
      @organization_user = create(:user, :lobby, organization: @organization)
      @position = create(:position)
      @agent = create(:agent, organization: @organization)
      @organization_user.manages.create(holder_id: @position.holder_id)
      login_as @organization_user
    end

    scenario 'visit index event page' do
      event = create(:event, user: @organization_user, title: 'New event for lobbies',
                      position: @position, organization_id: @organization.id)
      visit events_path
      expect(page).to have_content event.title
    end

    describe "New" do

      scenario 'Do not display caduced positions', :js do
        position_to = create(:position, to: Date.yesterday, title: "Gerente1")
        position_to = create(:position, title: "Gerente2")

        visit new_event_path

        page.execute_script %Q{ $('#event_holder_title').trigger('focus'); }
        find("#event_holder_title").native.send_key('Gerente')
        sleep 1
        within '.ui-autocomplete' do
          expect(page).to have_content "Gerente2"
          expect(page).not_to have_content "Gerente1"
        end
      end

      scenario 'visit new event form and render fields' do
        visit new_event_path

        expect(page).to have_selector('#event_title')
        expect(page).to have_selector('#event_location')
        expect(page).to have_selector('#event_description')
        expect(page).to have_selector('#event_general_remarks')
        expect(page).to have_selector('#event_lobby_scheduled')
        expect(page).to have_selector('#position_id', :visible => false)
        expect(page).to have_selector('#event_lobby_activity_true')
        expect(page).to have_selector('#event_lobby_activity_false')
        expect(page).to have_selector('#event_lobby_contact_firstname')
        expect(page).to have_selector('#event_lobby_contact_lastname')
        expect(page).to have_selector('#event_lobby_contact_phone')
        expect(page).to have_selector('#event_lobby_contact_email')
      end

      scenario 'visit new event form and not render fields' do
        visit new_event_path

        expect(page).not_to have_content('Organización que solicita la reunión')
        expect(page).not_to have_selector('#event_manager_general_remarks')
        expect(page).not_to have_selector('#event_scheduled')
        expect(page).not_to have_selector('#event_published_at')
      end

      scenario 'visit new event form and not render canceled option' do
        visit new_event_path

        expect(page).not_to have_content('Cancelar evento')
      end

      scenario 'visit new event form and not render rejected option' do
        visit new_event_path

        expect(page).not_to have_content('Rechazar evento')
      end

      scenario 'visit new event with organization without agents and redirect to edit_agents' do
        @agent.destroy

        visit new_event_path

        expect(page).to have_content('Editar agentes')
        expect(page).to have_content('Es necesario añadir algún agente para poder solicitar una reunión')
      end
    end

    describe "Create" do

      scenario 'visit new event page', :js do
        visit events_path

        click_link I18n.t('backend.new_requeseted_event')

        expect(page).to have_content I18n.t('backend.new_event')
      end

      scenario 'create new event with the minimum permitted fields', :js do
        ActionMailer::Base.deliveries.clear
        visit new_event_path

        fill_in :event_title, with: 'New event for a lobby'
        tinymce_fill_in :event_lobby_scheduled, '02/11/2017 06:30'
        tinymce_fill_in :event_general_remarks, 'General remarks'
        fill_in :event_location, with: 'New location'
        choose_autocomplete :event_organization_name, with: @organization.name, select: @organization.name
        within('#new_event_agent') do
          select "#{@agent.name} #{@agent.first_surname} #{@agent.second_surname}"
        end
        choose_autocomplete :event_position_title, with: @position.title, select: @position.title
        find("#position_id", :visible => false).set(@position.id)

        click_button "Enviar la solicitud"

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        open_email(@position.holder.users.first.email)

        expect(current_email.to).to eq(@position.holder.users.collect(&:email))
        expect(current_email.cc).to eq(nil)
        expect(current_email.bcc).to eq(["registrodelobbies@madrid.es"])

        expect(page).to have_content 'Registro creado correctamente'
      end

      scenario 'Visit new event page and create event without mandatory fields and display error', :js do
        visit new_event_path

        click_button "Enviar la solicitud"

        expect(page).to have_content "Este campo es obligatorio", count: 2
      end

      scenario 'Visit new event page and lobby_activity is checked and organization_name selected', :js do
        visit new_event_path

        find(:radio_button, "event_lobby_activity_true", checked: true)
        expect(find_field("event_organization_name").value).to eq @organization.name.to_s
      end

      scenario 'Visit new event page and not display specific admin/managers fields', :js do
        visit new_event_path

        expect(page).not_to have_field("event_scheduled")
        expect(page).not_to have_field("event_published_at")
      end

      scenario 'Should create organization with all fields without nesteds', :js do
        new_position = create(:position)
        visit new_event_path

        fill_in :event_title, with: "Title"
        fill_in :event_location, with: "Location"
        tinymce_fill_in(:event_description, "Description")
        tinymce_fill_in(:event_general_remarks, "General remarks")
        tinymce_fill_in(:event_lobby_scheduled, "Lobby scheduled proposal")
        choose_autocomplete :event_organization_name, with: @organization.name, select: @organization.name
        within('#new_event_agent') do
          select "#{@agent.name} #{@agent.first_surname} #{@agent.second_surname}"
        end
        choose_autocomplete :event_position_title, with: new_position.title, select: new_position.title
        find("#position_id", :visible => false).set(new_position.id)
        click_button "Enviar la solicitud"
        event = Event.where(title: "Title").first
        expect(page).to have_content "Registro creado correctamente"
        expect(event.title).to eq "Title"
        expect(event.location).to eq "Location"
        expect(event.description).to eq "<p>Description</p>"
        expect(event.general_remarks).to eq "<p>General remarks</p>"
        expect(event.lobby_scheduled).to eq "<p>Lobby scheduled proposal</p>"
        expect(event.position).to eq new_position
        expect(event.lobby_activity).to eq true
      end

      scenario 'Lobby user can see lobby contact info' do
        visit new_event_path

        within ".lobby-contact-info" do
          expect(page).to have_selector("input[value='#{@organization_user.first_name}']")
          expect(page).to have_selector("input[value='#{@organization_user.last_name}']")
          expect(page).to have_selector("input[value='#{@organization_user.phones}']")
          expect(page).to have_selector("input[value='#{@organization_user.email}']")
        end
      end

      describe "Lobby activity" do

        scenario 'When check lobby activity true display organization_name', :js do
          visit new_event_path
          expect(page).to have_selector("#event_organization_name", visible: false)

          choose :event_lobby_activity_true

          expect(page).to have_selector("#event_organization_name", visible: true)
        end

        scenario 'When fill by js organization_name fields are visibles', :js do
          visit new_event_path

          expect(page).to have_selector("#category-block", visible: true)
          expect(page).to have_selector(".represented-entities-block", visible: true)
          expect(page).to have_selector(".agents-block", visible: true)
        end

        scenario 'When fill by js organization_name display category', :js do
          visit new_event_path

          within "#category-block" do
            expect(page).to have_content @organization.category.name
          end
        end

        describe "Represented entity" do

          scenario 'When fill by js organization_name without represented_entity display organization on represented_entity selector', :js do
            visit new_event_path

            within ".represented-entities-block" do
              find("#event_represented_entities_link").click
            end

            within ".represented-entities-block" do
              expect(page).to have_selector("option[value='#{@organization.name}']")
            end
          end

          scenario 'When fill by js organization_name with represented_entity display represented_entity on represented_entity selector', :js do
            represented_entity = create(:represented_entity, organization: @organization)
            visit new_event_path

            within ".represented-entities-block" do
              find("#event_represented_entities_link").click
            end

            within ".represented-entities-block" do
              expect(page).to have_selector("option[value='#{represented_entity.name} #{represented_entity.first_surname} #{represented_entity.second_surname}']")
            end
          end

        end

        describe "Agents" do

          scenario 'When fill by js organization_name with agents display agent on agents selector', :js do
            agent = create(:agent, organization: @organization)
            visit new_event_path

            within ".agents-block" do
              find("#event_agents_link").click
            end

            within ".agents-block" do
              expect(page).to have_selector("option[value='#{agent.name} #{agent.first_surname} #{agent.second_surname}']")
            end
          end

        end

      end

    end

    describe "Edit" do

      scenario "Edit buttons enabled for events on_request" do
        event_requested = create(:event, user: @organization_user, title: 'Event on request', position: @position,
                                         organization: @organization)
        event_accepted = create(:event, user: @organization_user, title: 'Event accepted', position: @position,
                                        organization: @organization)
        event_requested.status = 0
        event_accepted.status = 1
        event_requested.save!
        event_accepted.save!


        visit events_path

        expect(page).to have_link("", href: edit_event_path(event_requested).to_s)
        expect(page).to_not have_link("", href: edit_event_path(event_accepted).to_s)
      end

      scenario "Edit buttons enabled for events on_request on show view" do
        event_requested = create(:event, user: @organization_user, title: 'Event on request', position: @position,
                                         organization: @organization)
        event_accepted = create(:event, user: @organization_user, title: 'Event accepted', position: @position,
                                        organization: @organization)
        event_requested.status = 0
        event_accepted.status = 1
        event_requested.save!
        event_accepted.save!

        visit event_path(event_requested)

        expect(page).to have_link("Editar")

        visit event_path(event_accepted)

        expect(page).to_not have_link("Editar")
      end

      scenario "User can edit events", :js do
        event_requested = create(:event, user: @organization_user, title: 'Event on request', position: @position,
                                         status: 0, organization: @organization)

        visit event_path(event_requested)

        click_link "Editar"

        fill_in :event_title, with: "Editar evento"
        click_button "Enviar la solicitud"

        expect(page).to have_content "Solicitudes de evento"
      end

      scenario 'Lobby user can see on page the name of the organization' do
        event = create(:event, user: @organization_user, organization_name: "Organization name", position: @position,
                               organization: @organization)

        visit edit_event_path(event)

        expect(page).not_to have_content('Organización que solicita la reunión')
      end

      scenario 'Lobby user can see lobby contact info' do
        event = create(:event, user: @organization_user, organization_name: "Organization name", lobby_contact_firstname: 'lobbyname',
                               lobby_contact_lastname: 'lobbylastname', lobby_contact_phone: '600123123',
                               lobby_contact_email: 'lobbyemail@email.com', organization: @organization)

        visit edit_event_path(event)

        within ".lobby-contact-info" do
          expect(page).to have_selector("input[value='lobbyname']")
          expect(page).to have_selector("input[value='lobbylastname']")
          expect(page).to have_selector("input[value='600123123']")
          expect(page).to have_selector("input[value='lobbyemail@email.com']")
        end
      end

      scenario 'Lobby user can update lobby contact info', :js do
        position = create(:position)
        event = create(:event, user: @organization_user, organization_name: "Organization name", lobby_contact_firstname: 'lobbyname',
                               lobby_contact_lastname: 'lobbylastname', lobby_contact_phone: '600123123',
                               lobby_contact_email: 'lobbyemail@email.com', organization: @organization,
                               position: position)
        visit edit_event_path(event)

        fill_in :event_lobby_contact_firstname, with: 'new lobbyname'
        fill_in :event_lobby_contact_lastname, with: 'new lobylastname'
        fill_in :event_lobby_contact_phone, with: '900878787'
        fill_in :event_lobby_contact_email, with: 'new_loby@email.com'
        find("#position_id", :visible => false).set(@position.id)
        click_button "Enviar la solicitud"
        event.reload

        expect(event.lobby_contact_firstname).to eq 'new lobbyname'
        expect(event.lobby_contact_lastname).to eq 'new lobylastname'
        expect(event.lobby_contact_phone).to eq '900878787'
        expect(event.lobby_contact_email).to eq 'new_loby@email.com'
      end

      scenario 'visit edit event form and not render rejected option' do
        event = create(:event, user: @organization_user)

        visit edit_event_path(event)

        expect(page).not_to have_content('Rechazar evento')
      end
    end

  end

  describe 'search by status' do

    background do
      @user_admin = create(:user, :admin)
      @position = create(:position)
      @user_admin.manages.create(holder_id: @position.holder_id)
      login_as @user_admin
    end

    scenario 'filter events by one status on multiselect', :js do
      event1 = create(:event, user: @user_admin, title: 'Test for check status requested', lobby_activity: true)
      event2 = create(:event, user: @user_admin, title: 'Test for check status accepted', lobby_activity: true)
      event1.status = 0
      event2.status = 1
      event1.save
      event2.save
      visit events_path

      select "Solicitado", from: :status
      click_button I18n.t('backend.search.button')

      expect(page).to have_content "Test for check status requested"
      expect(page).not_to have_content "Test for check status accepted"
    end

    scenario 'filter events by more than one status on multiselect' do
      event1 = create(:event, user: @user_admin, title: 'Test for check status requested', lobby_activity: true)
      event2 = create(:event, user: @user_admin, title: 'Test for check status accepted', lobby_activity: true)
      event3 = create(:event, user: @user_admin, title: 'Test for check status done', lobby_activity: true)
      event1.status = 0
      event2.status = 1
      event3.status = 2
      event1.save
      event2.save
      event3.save
      visit events_path

      select "Solicitado", from: :status
      select "Aceptado", from: :status
      click_button I18n.t('backend.search.button')

      expect(page).to have_content "Test for check status requested"
      expect(page).to have_content "Test for check status accepted"
      expect(page).not_to have_content "Test for check status done"
    end

  end

  describe 'Lobby user can only cancel an event tests' do

    background do
      @organization = create(:organization, entity_type: "lobby")
      @organization_user = create(:user, :lobby, organization: @organization)
      @event_agent = create(:event_agent)
      @position = create(:position)
      @agent = create(:agent, organization: @organization)
      @organization_user.manages.create(holder_id: @position.holder_id)
      login_as @organization_user
    end

    scenario "Lobby user can only cancel events", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent

      visit edit_event_path(event)

      expect(page).not_to have_content I18n.t('backend.accept_event')
      expect(page).not_to have_content I18n.t('backend.decline_event')
      expect(page).to have_content I18n.t('backend.cancel_event')
    end

    scenario "Lobby user correctly cancel events", :js do
      ActionMailer::Base.deliveries.clear
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent

      visit edit_event_path(event)

      click_link I18n.t('backend.cancel_event')
      tinymce_fill_in(:event_canceled_reasons, "reason")

      click_button "Enviar la solicitud"

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      open_email(@position.holder.users.first.email)

      expect(current_email.to).to eq(@position.holder.users.collect(&:email))
      expect(current_email.cc).to eq(nil)
      expect(current_email.bcc).to eq(["registrodelobbies@madrid.es"])

      expect(page).to have_content "Registro actualizado correctamente"
    end

  end

  describe 'Admin user can accept, decline or cancel an event tests' do

    background do
      @organization = create(:organization)
      @organization_user = create(:user, :admin, organization: @organization)
      @position = create(:position)
      @agent = create(:agent, organization: @organization)
      @organization_user.manages.create(holder_id: @position.holder_id)
      @event_agent = create(:event_agent)
      login_as @organization_user
    end

    scenario "Admin user can accept, decline and cancel events", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents <<  @event_agent

      visit edit_event_path(event)

      expect(page).to have_content I18n.t('backend.accept_event')
      expect(page).to have_content I18n.t('backend.decline_event')
      expect(page).to have_content I18n.t('backend.cancel_event')
    end
  end

  describe 'User user can accept, decline or cancel an event tests' do

    background do
      @organization = create(:organization)
      @organization_user = create(:user, :admin, organization: @organization)
      @position = create(:position)
      @agent = create(:agent, organization: @organization)
      @organization_user.manages.create(holder_id: @position.holder_id)
      @event_agent = create(:event_agent)
      login_as @organization_user
    end

    scenario "regular user can accept, decline and cancel events", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      visit edit_event_path(event)

      expect(page).to have_content I18n.t('backend.accept_event')
      expect(page).to have_content I18n.t('backend.decline_event')
      expect(page).to have_content I18n.t('backend.cancel_event')
    end

    scenario "User user correctly accept tests", :js do
      ActionMailer::Base.deliveries.clear
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent

      event.update(status: 'requested')

      visit edit_event_path(event)

      click_link I18n.t('backend.accept_event')

      click_button "Guardar"

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      open_email("user@email.com")

      expect(current_email.to).to eq(["user@email.com"])
      expect(current_email.cc).to eq(nil)
      expect(current_email.bcc).to eq(["registrodelobbies@madrid.es"])

      expect(page).to have_content "Registro actualizado correctamente"
    end

    scenario "User incorrect cancel tests", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent

      event.update(status: 'accepted')
      visit edit_event_path(event)

      click_link I18n.t('backend.cancel_event')
      click_button "Guardar"

      expect(page).to have_content I18n.translate('event.cancel_reasons_needed')
    end

    scenario "User correctly cancel events", :js do
      ActionMailer::Base.deliveries.clear
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent

      visit edit_event_path(event)

      click_link I18n.t('backend.cancel_event')
      tinymce_fill_in('event_canceled_reasons', "reason")

      click_button "Guardar"

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      open_email("user@email.com")

      expect(current_email.to).to eq(["user@email.com"])
      expect(current_email.cc).to eq(nil)
      expect(current_email.bcc).to eq(["registrodelobbies@madrid.es"])

      expect(page).to have_content "Registro actualizado correctamente"
    end

    scenario "User incorrect decline tests", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      event.update(status: 'requested')

      visit edit_event_path(event)

      click_link I18n.t('backend.decline_event')
      click_button "Guardar"

      expect(page).to have_content I18n.translate('event.decline_reasons_needed')
    end

    scenario "User correctly decline tests", :js do
      ActionMailer::Base.deliveries.clear
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      event.update(status: 'requested')
      manages_emails = event.position.holder.users.collect(&:email)
      to = ["user@email.com"] + manages_emails

      visit edit_event_path(event)

      click_link I18n.t('backend.decline_event')
      tinymce_fill_in('event_declined_reasons', "reason")

      click_button "Guardar"

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      open_email("user@email.com")

      expect(current_email.to).to eq(to)
      expect(current_email.cc).to eq(nil)
      expect(current_email.bcc).to eq(["registrodelobbies@madrid.es"])

      expect(page).to have_content "Registro actualizado correctamente"
    end

    scenario "An use can accept or decline an event only once", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      event.update(status: 'accepted')

      visit edit_event_path(event)

      expect(find_link(I18n.t('backend.accept_event'))[:disabled]).to eq "disabled"
      expect(find_link(I18n.t('backend.decline_event'))[:disabled]).to eq "disabled"
    end

    scenario "An use can cancel only accepted events", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      event.update(status: 'accepted')

      visit edit_event_path(event)

      expect(find_link(I18n.t('backend.cancel_event'))[:disabled]).not_to eq "disabled"
    end

    scenario "An use can cancel not accepted events", :js do
      event = create(:event, organization: @organization, user: @organization_user,
                             lobby_contact_email: "user@email.com", lobby_activity: true,
                             position: @position)
      event.event_agents << @event_agent
      event.update(status: 'requested')

      visit edit_event_path(event)

      expect(find_link(I18n.t('backend.cancel_event'))[:disabled]).not_to eq "disabled"
    end

  end
end
