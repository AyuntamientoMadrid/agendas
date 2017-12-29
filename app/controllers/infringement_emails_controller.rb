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
      if @infringement_email.errors.messages[:attachment].present?
        error = t('infringement_mailbox.error', error: @infringement_email.errors.messages[:attachment][0])
      else
        error = t('infringement_mailbox.affected_validation', error: @infringement_email.errors.messages[:affected][0])
      end
      flash.now.alert = error
      render action: 'new'
    end
  end

  private

    def email_params
      params.require(:infringement_email).permit(:subject, :link, :attachment, :description, :affected, :affected_referer )
    end
end
