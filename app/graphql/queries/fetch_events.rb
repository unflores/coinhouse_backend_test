class Queries::FetchEvents < Queries::BaseQuery

  type [Types::EventType], null: false

  argument :speaker_id, ID, required: false
  argument :kind, Integer, required: false
  argument :date, GraphQL::Types::ISO8601DateTime, required: false
  argument :location, String, required: false
  argument :limit, Integer, required: false

  def resolve(**kwargs)
    events = Event.includes(:user, :speaker, :attendees)

    case true
    when kwargs.key?(:speaker_id)
      events = events.where(speaker_id: kwargs[:speaker_id])
    when kwargs.key?(:kind)
      events = events.where(kind: kwargs[:kind])
    when kwargs.key?(:date)
      events = events.where(date: Date.parse(kwargs[:date]))
    when kwargs.key?(:location)
      events = events.where("LOCATION ILIKE ?", "%#{kwargs[:location]}%")
    when kwargs.key?(:limit)
      events = events.limit(kwargs[:limit])
    end

    events.order(start_at: :desc)
  end
end
