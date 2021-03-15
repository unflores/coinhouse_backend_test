class ThankYouWorker
  include Sidekiq::Worker

  def perform(*args)
    @event = Event.find(id)

    @event.attendees.each do |user|
      EventMailer.with(user: user, event: @event).thank_you.deliver_later
    end
  end
end
