$ ->
  template = """
  <table class="table table-hover">
    <tbody>
    {{#tracks}}
      <tr>
        <td>{{name}}</td>
        <td><a data-id="{{id}}" href="#"><i class="icon-plus-sign"></i></a></td>
      </td>
    {{/tracks}}
    <tbody>
  </table>
  """
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
    false