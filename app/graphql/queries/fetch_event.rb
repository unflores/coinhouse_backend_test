class Queries::FetchEvent < Queries::BaseQuery

  type Types::EventType, null: false
  argument :id, ID, required: true

  def resolve(id:)
    Event.includes(:user, :speaker, :attendees).find(id)
  rescue ActiveRecord::RecordNotFound => _e
    GraphQL::ExecutionError.new('Note does not exist.')
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}:"\
                                " #{e.record.errors.full_messages.join(', ')}")
  end
end
