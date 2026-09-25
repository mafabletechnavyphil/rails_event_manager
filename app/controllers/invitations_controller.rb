class InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :destroy]
  before_action :authorize_host!, only: [:create, :destroy]

  def index
    @invitations = current_user.invitations.where(status: :pending).includes(:event)
  end

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

    unless @invitation.accepted?
      @invitation.destroy
    end

    redirect_to @event, notice: "Invitation to #{@invitation.user.email} has been canceled."
  end

  def accept
    @invitation = current_user.invitations.find(params[:id])
    @event = @invitation.event

    ActiveRecord::Base.transaction do
      @invitation.accepted!
      @event.rsvps.create!(user: current_user)
    end

    redirect_to invitations_path, notice: "You have accepted the invitation to join #{@event.title}!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to invitations_path, alert: "Could not accept invitation: #{e.message}"
  end

  def reject
    @invitation = current_user.invitations.find(params[:id])
    @event = @invitation.event

    @invitation.declined!
    redirect_to invitations_path, notice: "You declined the invitation to #{@event.title}."
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
