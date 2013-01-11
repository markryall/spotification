$ ->
  show_tracks = (data) ->
    template = """
    <p>{{title}}</p>
    <ul id="tracks-list" data-role="listview" data-split-icon="plus" data-split-theme="d">
      {{#tracks}}
        <li>
          <a href="#">
            <img src="{{icon}}" class="ui-li-thumb">
            <h3 class="ui-li-heading">{{name}} ({{duration}})</h3>
            <p class="ui-li-desc">{{album}}</p>
            <p class="ui-li-desc">{{artists}}</p>
          </a>
          <a href="#" class='plus' data-track-id="{{id}}">remove</a>
        </li>
      {{/tracks}}
    </ul>
    """

    queue_track = ->
      remove = $(this).parent()
      $.post '/api/enqueue/track',
        id: $(this).data('track-id'),
        success: ->
          remove.slideUp()

    content = Mustache.to_html template, data
    $('#tracks .tracks-content').html content
    $.mobile.changePage '#tracks'
    $('#tracks-list').listview()
    $('#tracks-list a.plus').click queue_track

  $('#search-tracks-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/tracks',
      criteria: $('#search-tracks-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        show_tracks tracks: data.tracks, title: "#{data.info.num_results} tracks"
    false

  show_albums = (data) ->
    template = """
    <p>{{title}}</p>
    <ul id="albums-list" data-role="listview" data-split-icon="plus" data-split-theme="d">
      {{#albums}}
        <li>
          <a href="#" class='tracks' data-id="{{id}}">
            <img src="{{icon}}" class="ui-li-thumb">
            <h3 class="ui-li-heading">{{name}}</h3>
            <p class="ui-li-desc">{{artists}}</p>
            <p class="ui-li-desc">{{date}} - {{count}} tracks - {{duration}}</p>
          </a>
          <a href="#" class='plus' data-id="{{id}}">add</a>
        </li>
      {{/albums}}
    </ul>
    """

    queue_album = ->
      remove = $(this).parent()
      $.post '/api/enqueue/album',
        id: $(this).data('id'),
        success: ->
          remove.slideUp()

    show_album = ->
      $.get "/api/album/#{$(this).data('id')}",
        (data) ->
          console.log data
          show_tracks tracks: data.tracks, title: data.name

    content = Mustache.to_html template, data
    $('#albums .albums-content').html content
    $.mobile.changePage '#albums'
    $('#albums-list').listview()
    $('#albums-list a.plus').click queue_album
    $('#albums-list a.tracks').click show_album

  $('#search-albums-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/albums',
      criteria: $('#search-albums-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        show_albums albums: data.albums, title: "#{data.info.num_results} albums"
    false

  show_artists = (data) ->
    template = """
    <p>{{title}}</p>
    <ul id="artists-list" data-role="listview">
      {{#artists}}
        <li>
          <a href="#" data-id="{{id}}">{{name}}</a>
        </li>
      {{/artists}}
    </ul>
    """

    show_artist = ->
      $.get "/api/artist/#{$(this).data('id')}",
        (data) ->
          console.log data
          show_albums albums: data.albums, title: data.name

    content = Mustache.to_html template, data
    $('#artists .artists-content').html content
    $.mobile.changePage '#artists'
    $('#artists-list').listview()
    $('#artists-list a').click show_artist

  $('#search-artists-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/artists',
      criteria: $('#search-artists-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        show_artists artists: data.artists, title: "#{data.info.num_results} artists"
    false