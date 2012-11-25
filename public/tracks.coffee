$ ->
  $('.enqueue').click ->
    $.post '/track',
      track:
        id: $(this).data('id'),
        name: $(this).data('name'),
        album: $(this).data('album'),
        artists: $(this).data('artists')
    false