(function() {

  $(function() {
    var template;
    template = "{{#tracks}}\n  <li>{{name}}</li>\n{{/tracks}}";
    $('.enqueue').click(function() {
      $.post('/album', {
        id: $(this).data('id')
      });
      return false;
    });
    return $('.tracks').click(function() {
      var id;
      id = $(this).data('id');
      $.get("/tracks/" + id, {}, function(data) {
        var list;
        list = Mustache.to_html(template, data);
        return $("#tracks-" + id).append(list);
      });
      return false;
    });
  });

}).call(this);
