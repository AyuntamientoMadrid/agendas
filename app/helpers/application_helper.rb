module ApplicationHelper

  def show_headline(params)
    return (render 'visitors/headline/holder').to_s unless params[:holder].blank?
    return (render 'visitors/headline/search').to_s unless params[:keyword].blank?
    return (render 'visitors/headline/last').to_s
  end

  def current_url(new_params)
    url_for params.merge(new_params)
  end

  def current_urr_kk(new_params)
    url_for params.merge(new_params)
    url_for(:only_path => false, :overwrite_params=>nil)
  end

  def current_language
    message = t('header.page_language') + ' '
    message += I18n.locale == :es ? t('header.spanish') : t('header.english')
    message.html_safe
  end
end
