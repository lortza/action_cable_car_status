# ActionCable Car Status Practice App

Update the car status via the Rails Console and the status will appear on the Cars index via jQuery. Check out [this medium post](https://medium.com/rubyinside/action-cable-hello-world-with-rails-5-1-efc475b0208b) for a great tutorial.

* Ruby 2.5.0
* Rails ~> 5.0.1
* Postgres ~> 0.18
* Redis 3.3.1

## What it looks like

When a User 1 updates a record via the web app, it notifies all users if the car's `status` has changed:

![alt text](/public/screenshots/controller_update.png "Screenshot")

When an update to a car's `status` is made via the console, all users are notified.

![alt text](/public/screenshots/console_update.png "Screenshot")


## Getting Started

1. Start all of the services in separate terminal windows/tabs.

```ruby
#redis
redis-server

# rails server
rails server

# rails console
rails console
```

2. Go to `localhost:3000` in a browser tab and in an additional incognito window

3. Edit a car via the web interface.

4. See the normal notice in User 1's browser and the alert message in User 2's browser. Clear the alerts.

5. Update a car's status in the console and see the both users' browsers receive the alert.

```ruby
# rails console

Car.first.update_and_broadcast_status(status_id: Status.first.id)
```
