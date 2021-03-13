class Queries::FetchEvents < Queries::BaseQuery

  type [Types::EventType], null: false

  def resolve
    Event.all.order(created_at: :desc)
  end
end
