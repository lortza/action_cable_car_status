class Status < ApplicationRecord
  has_many :cars

  def display
    "#{name.titleize}"
  end

  def with_id
    "#{id}: #{name.titleize}"
  end
end
