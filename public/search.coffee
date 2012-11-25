$ ->
  $('.enqueue').click ->
    $.post '/track',
      id: $(this).data('id')