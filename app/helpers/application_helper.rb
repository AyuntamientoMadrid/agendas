module ApplicationHelper

  def show_headline(params)
    return (render 'visitors/headline/holder').to_s unless params[:holder].blank?
    return (render 'visitors/headline/search').to_s unless params[:keyword].blank?
    return (render 'visitors/headline/last').to_s
  end

  def current_url(new_params)
    url_for params.merge(new_params)
  end

  def show_date(date)
    output = date.present? ? date.strftime(t('date.formats.short')) : '----------'
    output.html_safe
  end

  def current_language
    message = t('header.page_language') + ' '
    message += I18n.locale == :es ? t('header.spanish') : t('header.english')
    message.html_safe
  end

  def show_user(user_id)
    if user_id.present?
      user = User.find(user_id)
      link_to(user.full_name, user_path(user)).html_safe
    end
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
    link_to url, class: "right dib dn hide-for-small-only" do
      content_tag(:span, "", class: "icon icon__export") + t('main.export')
    end
  end

end
