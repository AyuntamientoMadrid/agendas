class AdminController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  layout 'admin'
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_path, :alert => t('backend.access_denied')
  end

end
