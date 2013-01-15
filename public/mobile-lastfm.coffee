$ ->
  template = """
  <ul id="lastfm-list" data-role="listview">
    {{#tracks}}
      <li>
        <a href="#">
          <img src="{{image}}" class="ui-li-thumb">
          <h3 class="ui-li-heading">{{name}}</h3>
          <p class="ui-li-desc">{{album}}</p>
          <p class="ui-li-desc">{{artist}}</p>
          <p class="ui-li-desc">{{when}}</p>
        </a>
      </li>
    {{/tracks}}
  </ul>
  """
  load_lastfm = ->
    $.get '/api/lastfm', {}, (data) ->
      list = Mustache.to_html template, data
      $('#lastfm .lastfm-content').html list
      $('#lastfm-list').listview()

  $('div').live 'pagehide', (event, ui) ->
    load_lastfm() if $(ui.nextPage).attr('id') == 'lastfm'