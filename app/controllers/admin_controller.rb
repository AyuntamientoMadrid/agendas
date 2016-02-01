class AdminController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => t('backend.access_denied')
  end

  include PublicActivity::StoreController

  helper_method :current_user
  hide_action :current_user

end
