$ ->
  queue_template = """
  <ul id="queue-list" data-role="listview">
    {{#tracks}}
      <li>
        <img src="{{icon}}" class="ui-li-thumb">
        <h3 class="ui-li-heading">{{name}} ({{duration}})</h3>
        <p class="ui-li-desc">{{album}}</p>
        <p class="ui-li-desc">{{artists}}</p>
      </li>
    {{/tracks}}
  </ul>
  """

  load_queue = ->
    $.get '/api/queue', {}, (data) ->
      list = Mustache.to_html queue_template, data
      $('#queue-tracks').html list
      $('#queue-list').listview()

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