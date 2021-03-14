json.array! @events do |event|
  json.ignore_nil!
  json.id event.id
  json.creator event.user
  json.speaker event.speaker
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
