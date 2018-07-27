class Car < ApplicationRecord
  belongs_to :color
  belongs_to :status

  scope :ordered, -> { includes(:status, :color).order(:id) }
  # scope :ordered, -> { includes(:status, :color).order('statuses.number') }

  def to_broadcast
    {
      status: status.with_id,
      car_id: id,
      message: "The #{display} is now #{status.display}."
    }
  end

  def display
    "#{color.display} #{make} #{model}"
  end
end
