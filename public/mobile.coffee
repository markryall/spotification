$ ->
  $('#volume-slider').slider()
  $('#volume-slider').on 'slidestop', ->
    $.post '/api/volume',
      percentage: $('#volume-slider').val(),
      (data) ->
        $('#volume-slider').val data.percentage

  $('#rewind').click ->
    $.post '/api/player/rewind'
    false

  $('#playpause').click ->
    $.post '/api/player/playpause'
    false

  $('#fastforward').click ->
    $.post '/api/player/fastforward'
    false