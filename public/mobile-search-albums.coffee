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
        <a href="#" class='plus' data-album-id="{{id}}">add</a>
      </li>
    {{/albums}}
  </ul>
  """

  queue_album = ->
    remove = $(this).parent()
    $.post '/api/enqueue/album',
      id: $(this).data('album-id'),
      success: ->
        remove.slideUp()

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
        $('#albums-list a.plus').click queue_album
    false