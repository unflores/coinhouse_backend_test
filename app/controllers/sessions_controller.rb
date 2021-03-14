class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: params[:email])

    if !@user
      raise EventApi::Error.new('user not found', :not_found)
    elsif !@user.authenticate(params[:password])
      raise EventApi::Error.new('wrong credentials', :unauthorized)
    end

    @user.regenerate_token
    render json: { message: 'success', token: @user.token }, status: :created
  end
end
