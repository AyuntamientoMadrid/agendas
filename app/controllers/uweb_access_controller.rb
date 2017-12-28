class UwebAccessController < ApplicationController

  def uweb_sign_in
    uweb_api = UwebApi.new
    if valid_referer?(request.referer) && valid_params?(params) &&
      uweb_api.get_application_status.zero? &&
      uweb_api.get_user_status(params[:clave_usuario], params[:fecha_conexion]).zero? &&
      user = User.find_by(user_key: params[:clave_usuario])

      sign_in(:user, user)
      redirect_to events_home_path(user)
    else
      redirect_to root_path
    end
  end

  private

    def valid_params?(params)
      params['fecha_conexion'].present? &&
      params['clave_usuario'].present? &&
      params['clave_aplica'].present?
    end

    def valid_referer?(referer)
      #TODO: remove in order to ensure request is comming from Aire
      return true
      referer.include? Rails.application.secrets.uweb_referer_url
    end

end
