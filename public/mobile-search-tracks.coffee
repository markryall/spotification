$ ->
  template = """
  <p>{{info.num_results}} tracks</p>
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
    $.post '/api/enqueue',
      id: $(this).data('track-id'),
      success: ->
        remove.slideUp()

  $('#search-tracks-form').submit ->
    $.mobile.loading 'show'
    $.get '/api/search/tracks',
      criteria: $('#search-tracks-criteria').val(),
      (data) ->
        content = Mustache.to_html template, data
        $('#tracks .tracks-content').html content
        $.mobile.loading 'hide'
        $.mobile.changePage '#tracks'
        $('#tracks-list').listview()
        $('#tracks-list a.plus').click queue_track
    false