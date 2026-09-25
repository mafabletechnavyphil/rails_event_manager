class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :user

  enum :status, { pending: 0, accepted: 1, declined: 2 }, default: :pending

  validates :user_id, uniqueness: { scope: :event_id, message: "has already been invited" }
end
