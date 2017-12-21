class Users::SessionsController < Devise::SessionsController
  # layout 'admin'
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  #POST /resource/sign_in
  def create
    if current_user.try(:deleted_at)
      sign_out(current_user)
      redirect_to new_user_session_path, alert: t('devise.failure.locked')
    else
      super
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
