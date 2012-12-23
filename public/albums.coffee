$ ->
  template = """
  {{#tracks}}
    <li>{{name}}</li>
  {{/tracks}}
  """
  $('.enqueue').click ->
    $.post '/album',
      id: $(this).data('id'),
    false

  $('.tracks').click ->
    id = $(this).data('id')
    $.get "/tracks/#{id}", {}, (data) ->
      list = Mustache.to_html template, data
      $("#tracks-#{id}").append list
    false