class Car < ApplicationRecord
  belongs_to :color
  belongs_to :status

  scope :ordered, -> { includes(:status, :color).order(:id) }
  # scope :ordered, -> { includes(:status, :color).order('statuses.number') }

  def update_and_broadcast_status(car_params)
    self.update!(car_params)
    ActionCable.server.broadcast('status_notifications_channel', {status: self.status.with_id, car_id: self.id, krazy_message: "The #{self.display} is now #{self.status.display}." })
  end

  def display
    "#{color.display} #{make} #{model}"
  end
end
