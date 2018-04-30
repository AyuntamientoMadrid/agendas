include ActionView::Helpers::SanitizeHelper

class EventsExporter
  attr_accessor :fields

  ENUMS       = { status: "status" }.freeze

  TO_STRIP    =  [:description, :general_remarks, :declined_reasons, :canceled_reasons, :manager_general_remarks].freeze

  PRIVATE_FIELDS = ['status', 'notes', 'canceled_reasons', 'published_at', 'canceled_at', 'lobby_activity',
                    'lobby_scheduled', 'general_remarks', 'lobby_contact_firstname',
                    'accepted_at', 'declined_reasons', 'declined_at', 'user_name',
                    'lobby_contact_lastname', 'lobby_contact_email', 'lobby_contact_phone', 'manager_general_remarks'].freeze

  FIELDS = ['title', 'description', 'scheduled', 'updated_at', 'holder_name', 'position_names', 'location', 'status',
            'notes', 'canceled_reasons', 'published_at', 'canceled_at', 'lobby_activity',
            'organization_name', 'lobby_scheduled', 'general_remarks', 'lobby_contact_firstname',
            'accepted_at', 'declined_reasons', 'declined_at',
            'lobby_contact_lastname', 'lobby_contact_email', 'lobby_contact_phone', 'manager_general_remarks'].freeze

  def initialize(extended = false)
    @fields = FIELDS
    @fields = @fields - PRIVATE_FIELDS unless extended
  end

  def headers
    @fields.map { |f| I18n.t("events_exporter.#{f}") }
  end

  def event_to_row(event)
    @fields.map do |field|
      process_field(event, field)
    end
  end

  def windows_headers
    windows_array headers
  end

  def windows_event_row(event)
    windows_array event_to_row(event)
  end

  def save_csv(path)
    CSV.open(path, 'w', col_sep: ';', force_quotes: true, encoding: "UTF-8") do |csv|
      csv << windows_headers
      Event.find_each do |event|
        csv << windows_event_row(event)
      end
    end
  end

  def save_xls(path)
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.row(0).default_format = Spreadsheet::Format.new color: :blue, weight: :bold
    sheet.row(0).concat windows_headers
    index = 1
    Event.find_each do |event|
      sheet.row(index).concat windows_event_row(event)
      index += 1
    end

    book.write(path)
  end

  def save_json(path)
    data = []
    h = headers
    Event.find_each do |event|
      data << h.zip(windows_event_row(event)).to_h
    end
    File.open(path, "w") do |f|
      f.write(data.to_json)
    end
  end

  private

    def windows_array(values)
      values.map { |v| v.to_s.encode("UTF-8", invalid: :replace, undef: :replace, replace: '') }
    end

    def process_field(event, field)
      if ENUMS.keys.include?(field.to_sym)
        I18n.t "#{ENUMS[field.to_sym]}.#{event.send(field)}" if event.send(field).present?
      elsif event.send(field).class == TrueClass || event.send(field).class == FalseClass
        I18n.t "#{event.send(field)}"
      elsif TO_STRIP.include?(field.to_sym)
        strip_tags(event.send(field))
      elsif event.send(field).present? && Event.columns_hash[field].present? &&
            (Event.columns_hash[field].type == :date || Event.columns_hash[field].type == :datetime)
        I18n.l event.send(field), format: :short
      else
        event.send(field)
      end
    end
end
