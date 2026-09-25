class Event < ApplicationRecord
  has_many :rsvps, dependent: :destroy

  validates :title, :location, :event_date, presence: true
end
