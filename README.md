# ActionCable Car Status Practice App

This app tracks the status of vehicles on a car lot. It pushes updates to users' browsers via Action Cable when the `status_id` field of a car changes. It works both for browser-initiated and console-initiated updates (with the console as a stand-in for ETL-style db updates).

When a user updates a car's status via the browser, they get the normal Rails notice and all other users get a jQuery alert via Action Cable. If an update happens via the console, all users get an alert via Action Cable.

If you're looking for a tutorial on Action Cable alerts via the console, [this medium post](https://medium.com/rubyinside/action-cable-hello-world-with-rails-5-1-efc475b0208b) covers the basics.

* Ruby 2.5.0
* Rails ~> 5.0.1
* Postgres ~> 0.18
* Redis 3.3.1

## What it Looks Like

### Controller Updates

When User 1 updates a record via the web app, it notifies all _other_ users if the car's `status` field has changed:

![alt text](/public/screenshots/controller_update.png "Screenshot")

### Console Updates

When an update to a car's `status` field is made via the console, all users are notified.

![alt text](/public/screenshots/console.png "Screenshot")

![alt text](/public/screenshots/console_update.png "Screenshot")


## Getting Started

1. Start all of the services in separate terminal windows/tabs.

```ruby
# redis
redis-server

# rails server
rails server

# rails console
rails console
```

2. Go to `localhost:3000` in 2 browser windows, the second one as an incognito window.

3. Edit a car via the web interface.

4. See the normal notice in User 1's browser and the alert message in User 2's browser. Clear the alerts.

5. Update a car's status in the console (as below) and see the both users' browsers receive the alert.

```ruby
# rails console

CarWithBroadcast.new(Car.first, {status_id: Status.last.id}).save
```

## Explanation

Action Cable needs a channel for objects to subscribe to, so we set up a `status_notifications_channel` for our specific car status-related notifications.

```ruby
# app/channels/status_notifications_channel.rb

class StatusNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "status_notifications_channel"
  end
end
```

At some point, we need to initiate a broadcast and it _seems_ like the `cars_controller` would be a good place for that. But knowing when and what to broadcast is not the `cars_controller`'s job. All it cares about is passing data between the car views and data source. So we give it an object that already knows the broadcasting info, which lets the controller stick to its normal duties.

```ruby
# app/controllers/cars_controller.rb

def update
  # Pass the @car and its updated params to the `CarWithBroadcast` class
  @car_with_broadcast = CarWithBroadcast.new(@car, car_params)

  respond_to do |format|
    # And use that class's object just as we would have used the @car object under default circumstances
    if @car_with_broadcast.save
      format.html { redirect_to cars_url, notice: "The #{@car_with_broadcast.car.display} was successfully updated." }
      format.json { render cars_url, status: :ok, location: @car_with_broadcast.car }
    else
      format.html { render :edit }
      format.json { render json: @car_with_broadcast.car.errors, status: :unprocessable_entity }
    end
  end
end
```

The `CarWithBroadcast` class holds the what/when logic of broadcasting a car's status. So we give it a `@car` and let it initiate a broadcast to the `status_notifications_channel`.

```ruby
# app/models/car_with_broadcast.rb

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
      # Here we broadcast a message to the `status_notifications_channel` via ActionCable's methods
      ActionCable.server.broadcast('status_notifications_channel', car.to_broadcast) if @status_changed
      true
    else
      false
    end
  end
end
```

The `Car` class knows how it wants to talk about itself in a broadcast. Hence the `car.to_broadcast` above.

```ruby
# app/models/car.rb

class Car < ApplicationRecord
  ...
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
```

When the `status_notifications_channel` receives the broadcast data, we use jQuery to insert the HTML for the alert message.

```coffeescript
# app/assets/javascripts/channels/status_notifications.coffee

App.status_notifications = App.cable.subscriptions.create "StatusNotificationsChannel",
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').html("<p class='alert'>#{data.message} <span class='dismiss'>X</span></p>")
    $("##{data.car_id}").text("#{data.status}")
    $("##{data.car_id}").parent().addClass('highlight')

    $('.dismiss').on 'click', ->
      $('.alert').remove()
      $("##{data.car_id}").parent().removeClass('highlight')

```

So why not use an `after_update` callback in the `Car` model instead of creating the `CarWithBroadcast` class? With a model callback, we're inextricably tied to having a broadcast happen _every_ time a `car` object is updated. The `CarWithBroadcast` class gives us the flexibility to choose where and when we want to broadcast.

For example, updating a `car` in the console like this does not produce the alert,

```ruby
# rails console

Car.first.update!(status_id: 2)
```

and that makes for a better user experience if you need to make changes to the production database and you don't need users to witness the whole process. If we had used `after_update` the broadcast would have been sent -- and possibly without our realizing it.

The `CarWithBroadcast` class is not a _perfect_ solution. It feels a little clunky and the naming seems a touch off. But it's the solution for right now and when the code grows, a better name and purpose may reveal itself.
