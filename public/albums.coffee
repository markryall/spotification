$ ->
  template = """
  <table class="table table-hover">
    <tbody>
    {{#tracks}}
      <tr>
        <td>{{name}}</td>
        <td><a class="enqueue" data-id="{{id}}" href="#"><i class="icon-plus-sign"></i></a></td>
      </td>
    {{/tracks}}
    <tbody>
  </table>
  """

  handleEnqueueClick = ->
    hideMessage()
    $.post '/track', id: $(this).data('id'), (data)->
      showMessage "Track added to queue"
    false

  $('.enqueue').click ->
    hideMessage()
    $.post '/album', id: $(this).data('id'), (data)->
      showMessage "#{data.tracks} tracks queued"
    false

  $('.tracks').click ->
    id = $(this).data('id')
    $.get "/tracks/#{id}", {}, (data) ->
      list = Mustache.to_html template, data
      $("#tracks-#{id}").html list
      $("#tracks-#{id} .enqueue").click handleEnqueueClick
    false

  $('.enqueue').click handleEnqueueClick