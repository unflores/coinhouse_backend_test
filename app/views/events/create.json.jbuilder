json.message 'Event created'

json.event do
  json.id @event.id
  json.user_id @event.user_id
  json.speaker_id @event.speaker_id
  json.kind @event.kind
  json.name @event.name
  json.description @event.description
  json.limit(@event.limit) if @event.workshop?
  json.date @event.date.to_date
  json.start_at @event.start_at.strftime("%H:%M:%S %z")
  json.end_at @event.end_at.strftime("%H:%M:%S %z")
  json.create_at @event.created_at
  json.end_at @event.created_at
end

json.created_by do
  json.id @user.id
  json.first_name @user.first_name
  json.last_name @user.last_name
  json.email @user.email
  json.created_at @user.created_at
  json.updated_at @user.updated_at
end

json.speaker do
  json.id @speaker.id
  json.first_name @speaker.first_name
  json.last_name @speaker.last_name
  json.email @speaker.email
  json.created_at @speaker.created_at
  json.updated_at @speaker.updated_at
end
