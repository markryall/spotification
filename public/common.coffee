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