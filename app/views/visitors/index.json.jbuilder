json.events @events.results do |event|
  json.name = event.title
  json.description = strip_tags(event.description)
  json.location = event.location
  json.holder = event.position.holder.full_name
  json.date = event.scheduled
end
