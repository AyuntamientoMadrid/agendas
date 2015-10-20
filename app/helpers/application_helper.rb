module ApplicationHelper

  def show_headline(params)
    render 'headline/last' if params.present?
    render 'headline' if params[:holder]
    render 'headline/search' if params[:keyword]
  end

  def current_url(new_params)
    url_for params.merge(new_params)
  end

  def current_language
    message = t('header.page_language') + ' '
    message += I18n.locale == :es ? t('header.spanish') : t('header.english')
    message.html_safe
  end
end
