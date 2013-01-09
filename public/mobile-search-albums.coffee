$ ->
  template = """
  <p>{{info.num_results}} albums</p>
  <ul id="albums-list" data-role="listview" data-split-icon="plus" data-split-theme="d">
    {{#albums}}
      <li>
        <a href="#">
          <img src="{{icon}}" class="ui-li-thumb">
          <h3 class="ui-li-heading">{{name}}</h3>
          <p class="ui-li-desc">{{artists}}</p>
          <p class="ui-li-desc">{{date}} - {{count}} tracks - {{duration}}</p>
        </a>
        <a href="#" class='plus' data-track-id="{{id}}">add</a>
      </li>
    {{/albums}}
  </ul>
  """

  $('#search-albums-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/albums',
      criteria: $('#search-albums-criteria').val(),
      (data) ->
        $.mobile.loading 'hide'
        content = Mustache.to_html template, data
        $('#albums .albums-content').html content
        $.mobile.changePage '#albums'
        $('#albums-list').listview()
    false