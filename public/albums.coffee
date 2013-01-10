$ ->
  template = """
  <table class="table table-hover">
    <tbody>
    {{#tracks}}
      <tr>
        <td>{{name}} {{duration}}</td>
        <td><a class="enqueue-track" data-id="{{id}}" href="#"><i class="icon-plus-sign"></i></a></td>
      </td>
    {{/tracks}}
    <tbody>
  </table>
  """

  enqueueTrackClickHandler = ->
    hideMessage()
    $.post '/api/enqueue/track', id: $(this).data('id'), (data)->
      showMessage "#{data.name} added to queue"
    false

  $('.enqueue-album').click ->
    hideMessage()
    $.post '/api/enqueue/album', id: $(this).data('id'), (data)->
      showMessage "#{data.tracks} tracks queued"
    false

  $('.tracks').click ->
    hideMessage()
    id = $(this).data('id')
    $.get "/tracks/#{id}", {}, (data) ->
      showMessage "#{data.tracks.length} tracks retrieved"
      list = Mustache.to_html template, data
      $("#tracks-#{id}").html list
      $("#tracks-#{id} .enqueue-track").click enqueueTrackClickHandler
    false

  $('.enqueue-track').click enqueueTrackClickHandler