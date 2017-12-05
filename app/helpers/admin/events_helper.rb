module Admin
  module EventsHelper
    def check_filter_lobby_activity
      params[:lobby_activity] == '1'
    end

    def admin_or_mananger_edit?
      (current_user.admin? || current_user.user?) && params[:action] == "edit"
    end
  end
end
