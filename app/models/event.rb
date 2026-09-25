class Event < ApplicationRecord
  has_many :rsvps, dependent: :destroy
  has_many :attendees, through: :rsvps, source: :user
  belongs_to :user

  validates :title, :location, :event_date, presence: true
end
