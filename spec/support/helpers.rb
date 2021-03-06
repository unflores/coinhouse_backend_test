module Helpers

  def build_user
    User.new(first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             email: Faker::Internet.email,
             password: 'password')
  end

  def build_event
    event_params = {
      user_id: User.pluck(:id).sample,
      speaker_id: User.pluck(:id).sample,
      kind: rand(0..1),
      date: DateTime.now.tomorrow,
      start_at: DateTime.now.tomorrow.end_of_minute,
      end_at: DateTime.now.tomorrow.end_of_day,
      name: Faker::CryptoCoin.coin_name,
      location: Faker::WorldCup.stadium,
      description: Faker::Lorem.paragraph,
    }
    event_params[:limit] = rand(1..5) if event_params[:kind] == 0

    Event.new(event_params)
  end

  # class ControllerSpecHelper
  #   def authenticate
  #     token = User.last.token
  #     request.headers['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
  #   end
  # end
end

RSpec.configure do |config|
  config.include Helpers
end
