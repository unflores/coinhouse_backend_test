class UsersController < ApplicationController

  def create
    @user = User.find_or_create_by(email: user_params[:email]) do |user|
      user.first_name = user_params[:first_name]
      user.last_name = user_params[:last_name]
      user.password = user_params[:password]
    end

    raise ArgumentError.new(format_argument_error(@user.errors.messages)) if @user.invalid?

    render json: { message: 'account created' }, status: :created
  end

  private
  def user_params
    format_params(:user).permit(:first_name, :last_name, :email, :password)
  end
end
