module Admin
  module EventsHelper
    def check_filter_lobby_activity
      params[:lobby_activity] == '1'
    end

    def admin_or_mananger_edit?
      (current_user.admin? || current_user.user?) && params[:action] == "edit"
    end

    def calculate_firstname(event)
      firstname = ""
      if event.lobby_contact_firstname.present?
        firstname = event.lobby_contact_firstname
      elsif current_user.lobby?
        firstname = current_user.name
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

    def event_status_search_options (selected)
      rev=Hash.new
      t("backend.status").each_with_index {|(k,v),index| rev[v]=k}
      return options_for_select(rev, selected)
    end

  end
end
