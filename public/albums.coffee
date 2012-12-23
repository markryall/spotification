$ ->
  template = """
  {{#tracks}}
    <li>{{name}}</li>
  {{/tracks}}
  """
  $('.enqueue').click ->
    $.post '/album', id: $(this).data('id'), (data)->
      $('.alert .message').text("#{data.tracks} tracks queued")
      $('.alert').slideDown().removeClass('hidden')
    false

  $('.tracks').click ->
    id = $(this).data('id')
    $.get "/tracks/#{id}", {}, (data) ->
      list = Mustache.to_html template, data
      $("#tracks-#{id}").append list
    false