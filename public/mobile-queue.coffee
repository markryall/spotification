$ ->
  queue_template = """
  <ul id="queue-list" data-role="listview" data-split-icon="delete" data-split-theme="d">
    {{#tracks}}
      <li>
        <a href="#">
          <img src="{{icon}}" class="ui-li-thumb">
          <h3 class="ui-li-heading">{{name}} ({{duration}})</h3>
          <p class="ui-li-desc">{{album}}</p>
          <p class="ui-li-desc">{{artists}}</p>
        </a>
        <a href="#" class='remove' data-track-index="{{index}}">remove</a>
      </li>
    {{/tracks}}
  </ul>
  """

  remove_queued_track = ->
    remove = $(this).parent()
    $.post '/api/dequeue',
      id: $(this).data('track-index'),
      success: ->
        remove.slideUp()

  load_queue = ->
    $.get '/api/queue', {}, (data) ->
      list = Mustache.to_html queue_template, data
      $('#queue .queue-content').html list
      $('#queue-list').listview()
      $('#queue-list a.remove').click remove_queued_track

  $('div').live 'pagehide', (event, ui) ->
    load_queue() if $(ui.nextPage).attr('id') == 'queue'