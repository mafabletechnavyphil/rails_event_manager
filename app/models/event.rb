class Event < ApplicationRecord
  has_many :rsvps, dependent: :destroy
  has_many :attendees, through: :rsvps, source: :user
  belongs_to :user

  validates :title, :location, :event_date, presence: true

  has_many :invitations, dependent: :destroy
  has_many :invitees, through: :invitations, source: :user

  before_create :format_detail

  private
    def format_detail
      unless title.nil? && location.nil?
        self.title = title.titleize
        self.location = location.titleize
      end
    end
end
