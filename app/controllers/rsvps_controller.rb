class RsvpsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  # POST /events/:event_id/rsvps
  def create
    @rsvp = @event.rsvps.build(user: current_user)

    if @rsvp.save
      redirect_to @event, notice: "You have successfully joined the event!"
    else
      redirect_to @event, alert: "Unable to join event: #{@rsvp.errors.full_messages.to_sentence}"
    end
  end

  # DELETE /events/:event_id/rsvps/:id
  def destroy
    @rsvp = @event.rsvps.find_by!(id: params[:id])

    if @rsvp.user == current_user || @event.user == current_user
      @rsvp.destroy

      notice_message = if @event.user == current_user
        "Guest successfully removed from your event."
      else
        "You are no longer registered for this event."
      end

      redirect_to @event, notice: notice_message
    else
      redirect_to @event, alert: "You are not authorized to perform this action."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @event, alert: "You are not registered for this event."
  end

  private
    def set_event
      @event = Event.find(params[:event_id])
    end
end
