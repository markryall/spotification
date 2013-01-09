$ ->
  $('#search-albums-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/albums',
      criteria: $('#search-albums-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        console.log data
    false