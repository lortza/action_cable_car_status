App.status_notifications = App.cable.subscriptions.create "StatusNotificationsChannel",
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    $('#messages').html("<p class='alert'>#{data.krazy_message} <span class='dismiss'>X</span></p>")
    $("##{data.car_id}").text("#{data.status}")
    $("##{data.car_id}").parent().addClass('highlight')

    $('.dismiss').on 'click', ->
      $('.alert').remove()
      $("##{data.car_id}").parent().removeClass('highlight')
