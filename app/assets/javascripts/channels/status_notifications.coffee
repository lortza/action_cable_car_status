App.status_notifications = App.cable.subscriptions.create "StatusNotificationsChannel",
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').html("<p id='notice'>#{data}</p>")
