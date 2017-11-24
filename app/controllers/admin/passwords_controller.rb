module Admin
  class PasswordsController < AdminController

    layout "admin"

    def edit
    end

    def update
      if current_user.update(password_params)
        redirect_to root_path, notice: t("admin.passwords.update.notice")
      else
        flash.now[:alert] = t("admin.passwords.update.alert")
        render :edit
      end
    end

    protected

      def password_params
        params.require(:user).permit(:password, :password_confirmation)
      end

  end
end
