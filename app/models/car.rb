class Car < ApplicationRecord
  belongs_to :color
  belongs_to :status

  scope :ordered, -> { includes(:status, :color).order(:id) }
  # scope :ordered, -> { includes(:status, :color).order('statuses.number') }


 after_update do |car|
   ActionCable.server.broadcast('status_notifications_channel', {status: car.status.with_id, car_id: car.id, krazy_message: "The #{car.display} is now #{car.status.display}."})
 end

  def display
    "#{color.display} #{make} #{model}"
  end
end
