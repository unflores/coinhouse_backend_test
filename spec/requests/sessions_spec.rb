require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before(:all) { build_user.save }  #todo remove after fixing seeding issue
  let(:user) { User.last }

  describe "POST /create" do
    it 'sign in' do
      post login_path, params: { email: user.email, password: 'password' }
      expect(response.status).to eq 201
    end

    it 'return 404' do
      post login_path, params: { email: 'xxxx@xxxx.com', password: 'password' }
      expect(response.status).to eq 404
    end

    it 'return 401' do
      post login_path, params: { email: user.email, password: 'wrong' }
      expect(response.status).to eq 401
    end
  end
end
