module ApplicationHelper

  def show_headline(params)
    unless params[:holder].blank?
      holder = Holder.where(id: params[:holder]).first
      return (render 'visitors/headline/holder', holder: holder).to_s
    end
    return (render 'visitors/headline/search').to_s unless params[:keyword].blank?
    return (render 'visitors/headline/last').to_s
  end

  def current_url(new_params)
    url_for params.merge(new_params)
  end

  def show_date(date)
    output = date.present? ? I18n.l(date, format: :short) : '----------'
    output.html_safe
  end

  def current_language
    message = t('header.page_language') + ' '
    message += I18n.locale == :es ? t('header.spanish') : t('header.english')
    message.html_safe
  end

  def show_agenda_link(holder)
    link_to(holder.full_name,  agenda_path(holder.id,holder.full_name.parameterize)).html_safe
  end

  def form_field_errors(form, field)
    if form.object.errors[field].any?
      content_tag :span, class: "error error_field_rails" do
        field_errors = form.object.errors[field]
        field_errors.join(", ")
      end
    end
  end

  def export_link(url)
    link_to url, class: "right hide-for-small-only" do
      content_tag(:div) do
        concat(content_tag(:span, "", class: "icon icon__export"))
        concat(content_tag(:span, t('main.export')))
      end
    end
  end

end
