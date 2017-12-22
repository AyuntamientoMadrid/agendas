class AdminController < ApplicationController
  include PublicActivity::StoreController

  before_action :authenticate_user!
  before_action :events_root_path
  layout 'admin'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => t('backend.access_denied')
  end

  helper_method :get_title
  helper_method :current_user
  hide_action :current_user
  hide_action :get_title

  def events_root_path
    if current_user.user?
      @events_path = events_path({"utf8"=>"✓", "search_title"=>"", "search_person"=>"",
                              "status"=>["requested", "declined"], "lobby_activity"=>"1",
                              "controller"=>"events", "action"=>"index"})
    else
      @events_path = events_path
    end
  end

end
