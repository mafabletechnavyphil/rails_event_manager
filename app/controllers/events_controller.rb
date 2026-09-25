class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @events = Event.order(event_date: :asc)
  end

  # GET /events/:id
  def show
    @rsvp = @event.rsvps.build
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # GET /events/:id/edit
  def edit
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/:id
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id
  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully deleted.'
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :location, :event_date)
    end

    def authorize_owner!
      if @event.user != current_user
        redirect_to events_path, alert: "You are not authorized to modify this event."
      end
    end
end
