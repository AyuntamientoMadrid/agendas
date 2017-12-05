class InfringementEmailsController < ApplicationController

  invisible_captcha only: [:create], honeypot: :subsubject

  def new
    @infringement_email = InfringementEmail.new
  end

  def create
    @infringement_email = InfringementEmail.new(email_params)

    if @infringement_email.valid?
      UserMailer.infringement_email(@infringement_email, email_params[:attachment]).deliver_now
      redirect_to new_infringement_email_path, notice: t('infringement_mailbox.sent')
    else
      flash.now.alert = t('infringement_mailbox.error', error: @infringement_email.errors.messages[:attachment][0])
      render action: 'new'
    end
  end

  private

    def email_params
      params.require(:infringement_email).permit(:subject, :link, :attachment, :description, :name, :first_surname, :email, :phone)
    end
end
