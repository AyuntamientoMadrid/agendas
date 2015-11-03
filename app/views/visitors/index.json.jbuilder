json.events @events.results do |event|
  json.name = event.title
  json.description = event.description
end
