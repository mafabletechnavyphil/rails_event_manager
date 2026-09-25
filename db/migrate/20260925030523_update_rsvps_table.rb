class UpdateRsvpsTable < ActiveRecord::Migration[8.1]
  def change
    add_reference :rsvps, :user, null: false, foreign_key: true
  end
end
