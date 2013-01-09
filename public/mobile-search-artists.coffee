$ ->
  template = """
  <p>{{info.num_results}} artists</p>
  <ul id="albums-list" data-role="listview">
    {{#artists}}
      <li>
        <a href="#" data-track-id="{{id}}">{{name}}</a>
      </li>
    {{/artists}}
  </ul>
  """

  $('#search-artists-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/artists',
      criteria: $('#search-artists-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        content = Mustache.to_html template, data
        $('#artists .artists-content').html content
        $.mobile.changePage '#artists'
        $('#artists-list').listview()
    false