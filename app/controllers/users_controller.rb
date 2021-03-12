class UsersController < ApplicationController

  def create
    User.find_or_create_by(email: user_params[:email]) do |user|
      user.first_name = user_params[:first_name]
      user.last_name = user_params[:last_name]
    end
  end

  private
  def user_params
    user = params.require(:user)
    user = JSON.parse(user.gsub('=>', ':')) if user.is_a? String
    user = ActionController::Parameters.new(user)

    user.permit(:first_name, :last_name, :email)
  rescue => e
    raise e
  end
end
