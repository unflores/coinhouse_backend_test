require 'rails_helper'

RSpec.describe "Events", type: :request do
  before(:all) { build_event.save } #todo remove after fixing seeding issue
  let(:params) do
    {
      event: {
        kind: 'workshop',
        date: Date.today.to_s,
        start_at: Time.now,
        end_at: Time.now.end_of_day.strftime("%I:%M:%S %z"),
        name: 'Hello World',
        location: 'Narnia',
        description: Faker::Lorem.paragraph,
        limit: 5
      },
      user: {
        first_name: 'David',
        last_name: 'Copperfield',
        email: 'dave@yolo.com'
      },
      speaker: {
        first_name: 'Elon',
        last_name: 'Musk',
        email: 'elon@spacex.com'
      }
    }
  end

  describe "GET /index" do
    before(:each) { get events_path, as: :json }

    it 'return 200' do
      expect(response.status).to eq(200)
    end

    it 'return an event' do
      id = JSON.parse(response.body).first['id']
      expect(Event.find(id)).to be_a Event
    end
  end

  describe "POST /create" do
    it 'return 200' do
      post events_path, params: params, as: :json
      expect(response.status).to eq(200)
    end

    it 'return 422 when a params is missing' do
      post events_path, params: params.except!(:speaker), as: :json
      expect(response.status).to eq(422)
    end

    it 'return 422 when a validation failed' do
      data = params
      post events_path, params: data[:event].delete(:name), as: :json
      expect(response.status).to eq(422)
    end

    it 'return 422 when a date or time is not well formatted' do
      data = params
      data[:event][:start_at] = '!@#$!@#!'
      post events_path, params: data, as: :json
      expect(response.status).to eq(422)
    end
  end
end