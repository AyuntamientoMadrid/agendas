class EventsExporter
  FIELDS = ['title', 'description', 'scheduled', 'user_id', 'position_id', 'location', 'status',
            'notes', 'reasons', 'published_at', 'canceled_at',
            'organization_name', 'lobby_scheduled', 'general_remarks', 'lobby_contact_firstname',
            'lobby_contact_lastname', 'lobby_contact_email', 'lobby_contact_phone', 'manager_general_remarks'].freeze

  def headers
    FIELDS.map { |f| I18n.t("events_exporter.#{f}") }
  end

  def event_to_row(event)
    FIELDS.map do |f|
      event.send(f)
    end
  end

  def windows_headers
    windows_array headers
  end

  def windows_event_row(event)
    windows_array event_to_row(event)
  end

  def save_csv(path)
    CSV.open(path, 'w', col_sep: ';', force_quotes: true, encoding: "ISO-8859-1") do |csv|
      csv << windows_headers
      Event.with_lobby_activity_active.find_each do |event|
        csv << windows_event_row(event)
      end
    end
  end

  def save_xls(path)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold
    sheet.row(0).concat headers
    index = 1
    Event.with_lobby_activity_active.find_each do |event|
      sheet.row(index).concat windows_event_row(event)
      index += 1
    end

    book.write(path)
  end

  def save_json(path)
    data = []
    h = headers
    Event.with_lobby_activity_active.find_each do |event|
      data << h.zip(windows_event_row(event)).to_h
    end
    File.open(path, "w") do |f|
      f.write(data.to_json)
    end
  end

  private

    def windows_array(values)
      values.map { |v| v.to_s.encode("ISO-8859-1", invalid: :replace, undef: :replace, replace: '') }
    end

end
