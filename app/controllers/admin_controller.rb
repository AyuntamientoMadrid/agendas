class AdminController < ApplicationController
  include PublicActivity::StoreController

  before_action :authenticate_user!

  layout 'admin'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, alert: t('backend.access_denied')
  end

  helper_method :get_title
  helper_method :current_user
  hide_action :current_user
  hide_action :get_title

end
