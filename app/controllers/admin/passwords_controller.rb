module Admin
  class PasswordsController < AdminController

    layout "admin"

    def edit; end

    def update
      if current_user.update(password_params)
        sign_in(current_user, bypass: true)
        flash.now[:notice] = t("admin.passwords.update.notice")
      else
        flash.now[:alert] = t("admin.passwords.update.alert")
      end
      render :edit
    end

    protected

      def password_params
        params.require(:user).permit(:password, :password_confirmation)
      end

  end
end
