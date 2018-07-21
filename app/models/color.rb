class Color < ApplicationRecord
  has_many :cars

  def display
    name.titleize
  end
end
