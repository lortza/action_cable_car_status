class Car < ApplicationRecord
  belongs_to :color
  belongs_to :status

  scope :ordered, -> { includes(:status, :color).order('statuses.number') }


  def display
    "#{color.display} #{make} #{model}"
  end
end
