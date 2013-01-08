$ ->
  $('#volume-slider').slider()
  $('#volume-slider').on 'slidestop', ->
    $.post '/volume',
      percentage: $('#volume-slider').val(),
      (data) ->
        $('#volume-slider').val data.percentage