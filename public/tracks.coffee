$ ->
  $('.enqueue').on 'click', ->
    hideMessage()
    $.post '/track', id: $(this).data('id'), (data)->
      showMessage "Track added to queue"
    false