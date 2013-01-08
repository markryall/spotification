$ ->
  $('div').live 'pagehide', (event, ui) ->
    console.debug "Now on page #{$(ui.nextPage).attr 'id'}"

  $('#volume-slider').slider()
  $('#volume-slider').on 'slidestop', ->
    $.post '/volume',
      percentage: $('#volume-slider').val(),
      (data) ->
        $('#volume-slider').val data.percentage