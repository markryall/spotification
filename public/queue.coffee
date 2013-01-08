$ ->
  $('.dequeue').click ->
    remove = $(this).parent().parent().parent()
    $.post '/api/dequeue',
      id: $(this).data('id'),
      success: ->
        remove.slideUp()
    false