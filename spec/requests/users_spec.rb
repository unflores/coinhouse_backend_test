require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:params) do
    {
      user: {
        first_name: 'David',
        last_name: 'Copperfield',
        email: 'dave@yolo.com',
        password: 'password'
      }
    }
  end

  describe "POST /create" do
    it 'return 200' do
      post users_path, params: params, as: :json
      expect(response.status).to eq(201)
    end

    it 'return 422 when a validation failed' do
      data = params
      post users_path, params: data[:user].delete(:first_name), as: :json
      expect(response.status).to eq(422)
    end

    it 'return 422 when the email is not well formatted' do
      data = params
      data[:user][:email] = '!@#$!@#!'
      post users_path, params: data, as: :json
      expect(response.status).to eq(422)
    end
  end
end
