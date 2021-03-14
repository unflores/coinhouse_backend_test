class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::HttpAuthentication::Token

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message[/[^\\W\n]*/].capitalize }, status: :unprocessable_entity
  end

  rescue_from JSON::ParserError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from Date::Error do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from ArgumentError do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from EventApi::Error do |e|
    render json: { error: e.message }, status: e.status
  end

  rescue_from ActiveRecord::RecordNotUnique do |e|
    render json: { error: 'Already registered' }, status: :conflict
  end

  def format_params(sym)
    data = params.require(sym)
    data = JSON.parse(data.gsub('=>', ':')) if data.is_a? String
    data = ActionController::Parameters.new(data) unless data.is_a? ActionController::Parameters
    data
  end

  private
  def authenticate
    authenticate_or_request_with_http_token do |token,_|
      if current_user(token)
        ActiveSupport::SecurityUtils.secure_compare(token, @current_user.token)
      end
    end
  end

  def current_user(token = bearer_token)
    @current_user = User.find_by(token: token)
  end

  def bearer_token
    token_and_options(request)[0]
  end

  # todo render json error
  # def request_http_token_authentication(realm = "Application")
  #   self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  #   render json: { error: 'access denied' }, status: :unauthorized
  # end
end
