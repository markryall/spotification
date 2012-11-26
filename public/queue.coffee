$ ->
  $('.dequeue').click ->
    remove = $(this).parent().parent().parent()
    $.post '/dequeue',
      id: $(this).data('id'),
      success: ->
        remove.slideUp()
    false