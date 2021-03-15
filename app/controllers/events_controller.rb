class EventsController < ApplicationController

  before_action -> { set_user(:speaker) }, only: [:create]
  before_action :authenticate, only: [:create]
  before_action only: [:attend, :unregister] do
    set_event
    current_user || set_user(:current_user)
  end

  def index
    query = format_params(:q) if params[:q]
    @q = Event.ransack(query)

    @events = @q.result.includes(:user, :speaker, :attendees).limit(params[:per]).offset(params[:page])
  end

  def create
    @event = Event.new(user_id: @current_user.id, speaker_id: @speaker.id, **event_params)

    if @event.save
      render json: { message: 'Event created' }, status: :created
    else
      raise ArgumentError.new(@event.errors.full_messages)
    end
  end

  def attend
    @event.attendees << @current_user

    EventMailer.with(user: @current_user, event: @event).registration.deliver_later
    render json: { message: 'Registered' }, status: :created
  end

  def unregister
    @event.attendees.delete @current_user

    render json: { message: 'Unregistered' }, status: :ok
  end

  private
  def event_params
    event = format_params(:event)
    # todo put date parsing in model
    event[:start_at] = DateTime.parse("#{event[:date]} #{event[:start_at]}") if event[:start_at]
    event[:end_at] = DateTime.parse("#{event[:date]} #{event[:end_at]}") if event[:end_at]

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

  def set_event
    if params[:event_id]
      data = { id: params[:event_id] }
    else
      data = event_params
    end

    @event = Event.find_by(data)

    raise EventApi::Error.new('Event not found', :not_found) unless @event
  end
end
