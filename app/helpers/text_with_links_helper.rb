require 'rails_rinku'
module TextWithLinksHelper

  def safe_html_with_links(html)
    return if html.nil?
    Rinku.auto_link(html, :all, 'target="_blank" rel="nofollow"').html_safe
  end

end
