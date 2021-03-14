class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActionController::ParameterMissing do |e|
    render json: { error: e.message[/[^\\W\n]*/] }, status: :unprocessable_entity
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

  def format_params(sym)
    data = params.require(sym)
    data = JSON.parse(data.gsub('=>', ':')) if data.is_a? String
    data = ActionController::Parameters.new(data) unless data.is_a? ActionController::Parameters
    data
  end

  private
  def format_argument_error(errors)
    errors.map { |key,val| "#{key}: #{val}" }.join(', ')
  end

  def authenticate
    authenticate_or_request_with_http_token do |token,_|
      if current_user = User.find_by(token: token)
        ActiveSupport::SecurityUtils.secure_compare(token, current_user.token)
      end
    end
  end

  # todo render json error
  # def request_http_token_authentication(realm = "Application")
  #   self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
  #   render json: { error: 'access denied' }, status: :unauthorized
  # end
end
