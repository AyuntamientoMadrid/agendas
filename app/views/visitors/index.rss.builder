xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t("site_title")
    xml.description t("site_description")
    xml.link root_url
    @events.each do |event|
      xml.item do
        xml.title event.title
        xml.description event.description
        xml.pubDate event.updated_at.to_s(:rfc822)
        xml.link show_url(event.id)
        xml.guid show_url(event.id)
      end
    end
  end
end
