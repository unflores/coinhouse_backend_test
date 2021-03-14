json.array! @events do |event|
  json.ignore_nil!
  json.id event.id
  json.creator do
    json.id event.user.id
    json.first_name event.user.first_name
    json.last_name event.user.last_name
    json.email_name event.user.email
  end
  json.speaker do
    json.id event.speaker.id
    json.first_name event.speaker.first_name
    json.last_name event.speaker.last_name
    json.email event.speaker.email
  end
  json.kind event.kind
  json.name event.name
  json.description event.description
  if event.workshop? && (event.limit.to_i - event.attendees.count) > 0
    json.remaining_places (event.limit.to_i - event.attendees.count)
  elsif event.workshop?
    json.remaining_places 'full'
  end
  json.limit event.limit
  json.date event.date
  json.start_at event.start_at.strftime("%I:%M:%S %z")
  json.end_at event.end_at.strftime("%I:%M:%S %z")
end
