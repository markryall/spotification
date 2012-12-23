window.showMessage = (message) ->
  $('.message').text message
  $('.message').removeClass 'hidden'

window.hideMessage = ->
  $('.message').addClass 'hidden'

$ ->
  $('.volume_down').click ->
    $.post '/volume/down',
      id: $(this).data('level'),
      (data) ->
        $('a.volume').text data.percentage
    false

  $('.volume_up').click ->
    $.post '/volume/up',
      id: $(this).data('level'),
      (data) ->
        $('a.volume').text data.percentage
    false

  $('.rewind').click ->
    $.post '/player/rewind'
    false

  $('.playpause').click ->
    $.post '/player/playpause'
    false

  $('.fastforward').click ->
    $.post '/player/fastforward'
    false