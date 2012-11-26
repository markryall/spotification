$ ->
  $('.enqueue').click ->
    $.post '/album',
      id: $(this).data('id'),
    false