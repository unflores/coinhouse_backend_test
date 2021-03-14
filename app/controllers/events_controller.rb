class EventsController < ApplicationController

  before_action -> { set_user(:user); set_user(:speaker) }, only: [:create]
  before_action :authenticate, only: [:index, :create]

  def index
    query = format_params(:q) if params[:q]
    @q = Event.ransack(query)

    @events = @q.result.includes(:user, :speaker, :attendees).limit(params[:per]).offset(params[:page])
  end

  def create
    @event = Event.create(user_id: @user.id, speaker_id: @speaker.id, **event_params)

    if @event.valid?
      render json: { message: 'logged' }, status: :created
    else
      raise ArgumentError.new(format_argument_error(@event.errors.messages))
    end
  end

  private
  def event_params
    event = format_params(:event)
    event[:start_at] = DateTime.parse("#{event[:date]} #{event[:start_at]}")
    event[:end_at] = DateTime.parse("#{event[:date]} #{event[:end_at]}")

    event.permit(:kind, :date, :start_at, :end_at, :name, :location, :description, :limit)
  end

  def user_params(sym)
    user = format_params(sym)

    user.permit(:first_name, :last_name, :email)
  end

  def set_user(sym)
    data = user_params(sym)

    instance_variable_set("@#{sym}", User.find_or_create_by(email: data[:email]) { |user|
      user.first_name = data[:first_name]
      user.last_name = data[:last_name]
    })
  end
end
