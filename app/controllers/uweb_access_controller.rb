class UwebAccessController < ApplicationController

  def uweb_sign_in
    @uweb_api = UwebApi.new
    if (valid_request? request.referer) && (valid_params? params) && @uweb_api.get_application_status.zero? && @uweb_api.get_user_status(params[:clave_usuario],params[:fecha_conexion]).zero? && @user = User.find_by(user_key: params[:clave_usuario])
      sign_in(:user, @user)
      redirect_to events_path
    else
      redirect_to root_path
    end
  end

  private

  def valid_params?(params)
    params['fecha_conexion'].present? && params['clave_usuario'].present? && params['clave_aplica'].present?
  end

  def valid_request?(url)
    #TODO: remove in order to ensure request is comming from Aire
    return true
    url.include? Rails.application.secrets.uweb_referer_url
  end

end
