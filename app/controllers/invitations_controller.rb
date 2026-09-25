class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event
  before_action :authorize_host!

  def create
    @invitation = @event.invitations.build(invitation_params)

    if @invitation.save
      redirect_to @event, notice: "Invitation successfully sent!"
    else
      redirect_to @event, alert: "Failed to send invitation."
    end
  end

  def destroy
    @invitation = @event.invitations.find(params[:id])
    @invitation.destroy
    redirect_to @event, notice: "Invitation to #{@invitation.user.email} has been canceled."
  end

  private
    def set_event
      @event = Event.find(params[:event_id])
    end

    def authorize_host!
      if @event.user != current_user
        redirect_to @event, alert: "Only the event host can manage invitations."
      end
    end

    def invitation_params
      params.require(:invitation).permit(:user_id)
    end
end
