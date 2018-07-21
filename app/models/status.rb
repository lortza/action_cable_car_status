class Status < ApplicationRecord
  has_many :cars

  def display
    "#{number}: #{name.titleize}"
  end
end
