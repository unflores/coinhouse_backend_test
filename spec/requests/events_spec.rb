require 'rails_helper'

RSpec.describe "Events", type: :request do
  def format_token
    ActionController::HttpAuthentication::Token.encode_credentials(User.last.token)
  end

  # todo remove after fixing seeding issue
  before(:all) do
    2.times { build_event.save }
    build_user.save
  end

  let(:params) do
    {
      event: {
        kind: 'workshop',
        date: DateTime.now.tomorrow.to_date,
        start_at: DateTime.now.tomorrow.end_of_minute.strftime("%H:%M:%S %z"),
        end_at: DateTime.now.tomorrow.end_of_day,
        name: 'Hello World',
        location: 'Narnia',
        description: Faker::Lorem.paragraph,
        limit: 5
      },
      current_user: {
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
    context 'without params' do
      before(:each) { get events_path, as: :json }

      it 'return 200' do
        expect(response.status).to eq(200)
      end

      it 'return an event' do
        id = JSON.parse(response.body).first['id']
        expect(Event.find(id)).to be_a Event
      end
    end

    context 'with params' do
      let(:event) { Event.last }
      let(:query) do
        { q: {}, per: 1, page: 0 }
      end

      it 'return search' do
        query[:q] = { id_eq: event.id }
        get events_path(query), as: :json

        id = JSON.parse(response.body).first['id']
        expect(Event.find(id)).to eq event
      end

      it 'return last' do
        query[:page] = Event.count - 1
        get events_path(query), as: :json

        id = JSON.parse(response.body).first['id']
        expect(Event.find(id)).to eq event
      end

      it 'return nothing' do
        query[:per] = 0
        get events_path(query), as: :json

        expect(JSON.parse(response.body)).to be_empty
      end
    end
  end

  describe "POST /create" do
    it 'return 201' do
      post events_path, params: params, as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(201)
    end

    it 'return 422 when a validation failed' do
      data = params.clone
      data[:event] = data[:event].except(:name)
      post events_path, params: data, as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(422)
    end

    it 'return 404 when a params is missing' do
      post events_path, params: params.except(:speaker), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(404)
    end

    it 'return 422 when a date or time is not well formatted' do
      data = params
      data[:event][:date] = '!@#$!@#!'
      post events_path, params: data, as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(422)
    end
  end

  describe 'POST /:id/attend' do
    it 'return 201' do
      post event_attend_path(Event.last.id), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(201)
    end

    it 'return 201' do
      post event_attend_path(Event.last.id), params: params.slice(:current_user), as: :json
      expect(response.status).to eq(201)
    end

    it 'return 404' do
      post event_attend_path(81379124), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(404)
    end

    it 'return 409' do
      post event_attend_path(Event.last.id), as: :json, headers: { Authorization: format_token }
      post event_attend_path(Event.last.id), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(409)
    end

    it 'return 404' do
      post event_attend_path(Event.last.id), as: :json
      expect(response.status).to eq(404)
    end
  end

  describe 'POST /:id/unregister' do
    it 'return 200' do
      post event_unregister_path(Event.last.id), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(200)
    end

    it 'return 200' do
      post event_unregister_path(Event.last.id), params: params.slice(:current_user), as: :json
      expect(response.status).to eq(200)
    end

    it 'return 404' do
      post event_unregister_path(81379124), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(404)
    end

    it 'return 404' do
      post event_unregister_path(Event.last.id), as: :json

      expect(response.status).to eq(404)
    end
  end

  let(:data) do
    {
      event: {
        name: Event.last.name,
        location: Event.last.location,
      },
      current_user: {
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

  describe 'POST /attend' do
    it 'return 201' do
      post attend_events_path, params: data.slice(:event), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(201)
    end

    it 'return 201' do
      post attend_events_path, params: data.slice(:current_user, :event), as: :json
      expect(response.status).to eq(201)
    end

    it 'return 404' do
      post attend_events_path, as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(404)
    end

    it 'return 404' do
      post attend_events_path, as: :json
      expect(response.status).to eq(404)
    end

    it 'return 409' do
      post attend_events_path, params: data.slice(:event), headers: { Authorization: format_token }, as: :json
      post attend_events_path, params: data.slice(:event), headers: { Authorization: format_token }, as: :json
      expect(response.status).to eq(409)
    end

    it 'return 409' do
      post attend_events_path, params: data.slice(:current_user, :event), as: :json, headers: { Authorization: format_token }
      post attend_events_path, params: data.slice(:current_user, :event), as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(409)
    end
  end

  describe 'POST /unregister' do
    it 'return 200' do
      post events_path, params: data, as: :json, headers: { Authorization: format_token }
      post unregister_events_path, params: data.slice(:event), headers: { Authorization: format_token }, as: :json
      expect(response.status).to eq(200)
    end

    it 'return 200' do
      post unregister_events_path, params: data.slice(:current_user, :event), as: :json
      expect(response.status).to eq(200)
    end

    it 'return 404' do
      post unregister_events_path, as: :json, headers: { Authorization: format_token }
      expect(response.status).to eq(404)
    end

    it 'return 404' do
      post unregister_events_path, as: :json
      expect(response.status).to eq(404)
    end
  end
end
