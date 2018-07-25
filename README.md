# ActionCable Car Status Practice App

Update the car status via the Rails Console and the status will appear on the Cars index via jQuery.

* Ruby 2.5.0
* Rails ~> 5.0.1
* Postgres ~> 0.18
* Redis 3.3.1


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

2. Go to `localhost:3000`

3. Update a car's status in the console and see the `cars#index` view change

```ruby
# rails console

Car.first.update!(status_id: Status.first.id)
```
