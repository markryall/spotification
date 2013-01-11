window.showMessage = (message) ->
  $('.message').text message
  $('.message').removeClass 'hidden'

window.hideMessage = ->
  $('.message').addClass 'hidden'

$ ->
  $('.volume_down').click ->
    $.post '/api/volume/down',
      id: $(this).data('level'),
      (data) ->
        $('.volume').text data.percentage
    false

  $('.volume_up').click ->
    $.post '/api/volume/up',
      id: $(this).data('level'),
      (data) ->
        $('.volume').text data.percentage
    false

  $('.rewind').click ->
    $.post '/api/player/rewind'
    false

  $('.playpause').click ->
    hideMessage()
    $.post '/api/player/playpause', {}, (data) ->
      showMessage "Player is now #{data.state}"
    false

  $('.fastforward').click ->
    $.post '/api/player/fastforward'
    false