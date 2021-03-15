class RecallWorker
  include Sidekiq::Worker

  def perform(id)
    @event = Event.find(id)

    @event.attendees.each do |user|
      EventMailer.with(user: user, event: @event).recall.deliver_later
    end
  end
end
