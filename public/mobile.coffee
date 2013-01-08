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
    $.post '/dequeue',
      id: $(this).data('track-index'),
      success: ->
        remove.slideUp()

  load_queue = ->
    $.get '/api/queue', {}, (data) ->
      list = Mustache.to_html queue_template, data
      $('#queue-tracks').html list
      $('#queue-list').listview()
      $('#queue-tracks a.remove').click remove_queued_track

  $('div').live 'pagehide', (event, ui) ->
    switch $(ui.nextPage).attr('id')
      when 'queue' then load_queue()

  $('#volume-slider').slider()
  $('#volume-slider').on 'slidestop', ->
    $.post '/volume',
      percentage: $('#volume-slider').val(),
      (data) ->
        $('#volume-slider').val data.percentage

  load_queue()