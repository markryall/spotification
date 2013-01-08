$ ->
  $('#search-tracks-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/tracks',
      criteria: $('#search-tracks').val(),
      (data) ->
        console.debug data
        $.mobile.loading 'hide'
        $.mobile.changePage '#tracks'
    false