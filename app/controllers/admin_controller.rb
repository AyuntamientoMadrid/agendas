class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!

  #skip_authorization_check
  #before_action :verify_administrator

  private

  #  def verify_administrator
  #    raise CanCan::AccessDenied unless current_user.try(:administrator?)
  #  end

end
