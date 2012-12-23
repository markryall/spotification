$ ->
  template = """
  {{#tracks}}
    <li>{{name}}</li>
  {{/tracks}}
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
      $("#tracks-#{id}").append list
    false