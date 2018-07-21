class Car < ApplicationRecord
  belongs_to :color
  belongs_to :status

  scope :ordered, -> { includes(:status).order('statuses.number') }


  def display
    "#{color.display} #{make} #{model}"
  end
end
