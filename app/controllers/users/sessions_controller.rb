class Users::SessionsController < Devise::SessionsController

  def create
    if current_user.try(:deleted_at)
      sign_out(current_user)
      redirect_to new_user_session_path, alert: t('devise.failure.locked')
    else
      super
    end
  end

end
