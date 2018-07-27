class CarWithBroadcast
  attr_reader :car

  def initialize(car, params)
    @car = car
    @car.assign_attributes(params)
    @status_changed = @car.status_id_changed?
  end

  def save
    if car.valid?
      car.save
      ActionCable.server.broadcast('status_notifications_channel', car.to_broadcast) if @status_changed
      true
    else
      false
    end
  end
  
end
