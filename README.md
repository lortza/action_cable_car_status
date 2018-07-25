# ActionCable Car Status Practice App

Update the car status via the Rails Console and the status will appear on the Cars index via jQuery. Check out [this medium post](https://medium.com/rubyinside/action-cable-hello-world-with-rails-5-1-efc475b0208b) for a great tutorial.

* Ruby 2.5.0
* Rails ~> 5.0.1
* Postgres ~> 0.18
* Redis 3.3.1

## What it looks like

![alt text](/public/screenshots/cars_index1.png "Screenshot")


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
