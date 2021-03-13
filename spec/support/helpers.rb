module Helpers

  def build_user
    User.new(first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             email: Faker::Internet.email)
  end

  def build_event
    event_params = {
      user_id: User.pluck(:id).sample,
      speaker_id: User.pluck(:id).sample,
      kind: rand(0..1),
      date: Date.today,
      start_at: 1.second.after,
      end_at: 2.seconds.after,
      name: Faker::CryptoCoin.coin_name,
      location: Faker::WorldCup.stadium,
      description: Faker::Lorem.paragraph,
    }
    event_params[:limit] = rand(1..5) if event_params[:kind] == 0

    Event.new(event_params)
  end
end

RSpec.configure do |config|
  config.include Helpers
end
