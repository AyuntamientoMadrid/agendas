module Admin
  module EventsHelper
    def check_filter_lobby_activity
      params[:lobby_activity] == '1'
    end
  end
end
