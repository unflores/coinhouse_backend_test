class ApplicationController < ActionController::API

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
end
