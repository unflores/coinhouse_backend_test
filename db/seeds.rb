ActiveRecord::Base.transaction {

  25.times do
    user_params = {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email
    }

    User.create(user_params)
  end

  10.times do
    kind = rand(0..1)
    date = Faker::Time.forward(days: 1, period: :morning)
    event_params = {
      user_id: User.pluck(:id).sample,
      speaker_id: User.pluck(:id).sample,
      kind: kind,
      date: date,
      start_at: Faker::Time.between_dates(from: date, to: date + 1.second),
      end_at: Faker::Time.between_dates(from: date + 1.second, to: date.end_of_day),
      name: Faker::CryptoCoin.coin_name,
      location: Faker::WorldCup.stadium,
      description: Faker::Lorem.paragraph,
    }
    event_params[:limit] = rand(1..5) if kind == 0

    Event.create(event_params)
  end
}
