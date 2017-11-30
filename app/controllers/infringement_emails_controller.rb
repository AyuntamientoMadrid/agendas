class InfringementEmailsController < ApplicationController

  invisible_captcha only: [:create], honeypot: :subsubject

  def new
    @infringement_email = InfringementEmail.new
  end

  def create
    @infringement_email = InfringementEmail.new(email_params[:subject], email_params[:description], email_params[:link], email_params[:attachment])

    if @infringement_email.valid?
      # TODO: send message here
      UserMailer.infringement_email(@infringement_email, email_params[:attachment]).deliver
      redirect_to new_infringement_email_path, notice: "Email enviado correctamente"
    else
      render :action => 'new'
    end
  end

  private

    def email_params
      params.require(:infringement_email).permit(:subject, :link, :attachment, :description)
    end
end
