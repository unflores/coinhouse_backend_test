json.array! @events do |event|
  json.id event.id
  json.kind event.kind
  json.speaker event.speaker
  json.name event.name
  json.description event.description
  json.limit(event.limit) if event.workshop?
  json.date event.date
  json.start_at event.start_at.strftime("%I:%M:%S %z")
  json.end_at event.end_at.strftime("%I:%M:%S %z")
end
