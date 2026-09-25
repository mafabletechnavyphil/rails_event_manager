class Rsvp < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :user_id, uniqueness: { scope: :event_id, message: "has already attend to this event" }
end
