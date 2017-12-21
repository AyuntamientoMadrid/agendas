module Admin
  module EventsHelper
    def check_filter_lobby_activity
      params[:lobby_activity] == '1'
    end

    def admin_or_mananger_edit?
      (current_user.admin? || current_user.user?) &&
      (params[:action] == "edit" || params[:action] == "update")
    end

    def calculate_firstname(event)
      if event.lobby_contact_firstname.present?
        event.lobby_contact_firstname
      elsif current_user.lobby?
        current_user.first_name
      else
        ""
      end
    end

    def calculate_lastname(event)
      if event.lobby_contact_lastname.present?
        event.lobby_contact_lastname
      elsif current_user.lobby?
        current_user.last_name
      else
        ""
      end
    end

    def calculate_phone(event)
      if event.lobby_contact_phone.present?
        event.lobby_contact_phone
      elsif current_user.lobby?
        current_user.phones
      else
        ""
      end
    end

    def calculate_email(event)
      if event.lobby_contact_email.present?
        event.lobby_contact_email
      elsif current_user.lobby?
        current_user.email
      else
        ""
      end
    end

    def event_status_search_options(selected)
      rev = {}
      t("backend.status").each_with_index { |(k, v)| rev[v] = k }
      options_for_select(rev, selected)
    end

    def holder_name_by_position_id(position_id)
      Position.find(position_id).full_name if position_id.present?
    end

    def event_attachments_download_dropdown_id(event)
      "event_#{event.id}_attachments_dropdown"
    end
  end
end
