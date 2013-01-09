$ ->
  $('#search-artists-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/artists',
      criteria: $('#search-artists-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        console.log data
    false