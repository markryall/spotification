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

  show_artists = (data) ->
    template = """
    <p>{{title}}</p>
    <ul id="albums-list" data-role="listview">
      {{#artists}}
        <li>
          <a href="#" data-track-id="{{id}}">{{name}}</a>
        </li>
      {{/artists}}
    </ul>
    """

    content = Mustache.to_html template, data
    $('#artists .artists-content').html content
    $.mobile.changePage '#artists'
    $('#artists-list').listview()

  $('#search-artists-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/artists',
      criteria: $('#search-artists-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        show_artists artists: data.artists, title: "#{data.info.num_results} albums"
    false