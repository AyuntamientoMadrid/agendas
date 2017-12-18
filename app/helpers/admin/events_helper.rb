module Admin
  module EventsHelper
    def check_filter_lobby_activity
      params[:lobby_activity] == '1'
    end

    def admin_or_mananger_edit?
      (current_user.admin? || current_user.user?) && params[:action] == "edit"
    end

    def event_edit?
      params[:action] == "edit"
    end

    def calculate_firstname(event)
      firstname = ""
      if event.lobby_contact_firstname.present?
        firstname = event.lobby_contact_firstname
      elsif current_user.lobby?
        firstname = current_user.first_name
      else
        firstname
      end
    end

    def calculate_lastname(event)
      lastname = ""
      if event.lobby_contact_lastname.present?
        lastname = event.lobby_contact_lastname
      elsif current_user.lobby?
        lastname = current_user.last_name
      else
        lastname
      end
    end

    def calculate_phone(event)
      phone = ""
      if event.lobby_contact_phone.present?
        phone = event.lobby_contact_phone
      elsif current_user.lobby?
        phone = current_user.phones
      else
        phone
      end
    end

    def calculate_email(event)
      email = ""
      if event.lobby_contact_email.present?
        email = event.lobby_contact_email
      elsif current_user.lobby?
        email = current_user.email
      else
        email
      end
    end

    def event_status_search_options(selected)
      rev = {}
      t("backend.status").each_with_index { |(k, v)| rev[v] = k }
      options_for_select(rev, selected)
    end

    def holder_name_by_position_id (position_id)
      holder_title = Position.find(position_id).full_name if position_id.present?
    end

    def event_attachments_download_dropdown_id(event)
      "event_#{event.id}_attachments_dropdown"
    end

  end
end
