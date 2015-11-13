class UwebAccessController < ApplicationController

  def uweb_sign_in
    if (valid_request? request.referer) && (valid_params? params) && @uweb_api.get_application_status.zero? && @uweb_api.get_user_status(params[:clave_usuario],params[:fecha_conexion]).zero? && @user = User.find_by(user_key: params[:clave_usuario])
      sign_in(:user, @user)
      redirect_to events_path
    else
      redirect_to root_path
    end
    # redirect_to root_path unless valid_request? request.referer
    # redirect_to root_path unless valid_params? params
    # @uweb_api = UwebApi.new
    # redirect_to root_path unless @uweb_api.get_application_status.zero?
    # redirect_to root_path unless @uweb_api.get_user_status(params[:clave_usuario],params[:fecha_conexion]).zero?
    # redirect_to root_path unless @user = User.find_by(user_key: params[:clave_usuario])
    # sign_in(:user, @user)
    # redirect_to events_path
  end

  private

  def valid_params?(params)
    params['fecha_conexion'].present? && params['clave_usuario'].present? && params['clave_aplica'].present?
  end

  def valid_request?(url)
    return true
    url.include? Rails.application.secrets.uweb_referer_url
  end

end
