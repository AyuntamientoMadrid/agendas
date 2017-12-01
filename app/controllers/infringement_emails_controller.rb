class InfringementEmailsController < ApplicationController

  invisible_captcha only: [:create], honeypot: :subsubject

  def new
    @infringement_email = InfringementEmail.new
  end

  def create
    @infringement_email = InfringementEmail.new(email_params)

    if @infringement_email.valid?
      UserMailer.infringement_email(@infringement_email, email_params[:attachment]).deliver
      redirect_to new_infringement_email_path, notice: "Email enviado correctamente"
    else
      flash.now.alert = "El fichero #{@infringement_email.errors.messages[:attachment][0]}"
      render action: 'new'
    end
  end

  private

    def email_params
      params.require(:infringement_email).permit(:subject, :link, :attachment, :description)
    end
end
