class EventsController < ApplicationController

  def index
    @events = Event.includes(:user, :speaker, :attendees)
  end
end
