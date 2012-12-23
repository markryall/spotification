(function() {

  $(function() {
    var template;
    template = "<table class=\"table table-hover\">\n  <tbody>\n  {{#tracks}}\n    <tr>\n      <td>{{name}}</td>\n      <td><a data-id=\"{{id}}\" href=\"#\"><i class=\"icon-plus-sign\"></i></a></td>\n    </td>\n  {{/tracks}}\n  <tbody>\n</table>";
    $('.enqueue').click(function() {
      hideMessage();
      $.post('/album', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("" + data.tracks + " tracks queued");
      });
      return false;
    });
    return $('.tracks').click(function() {
      var id;
      id = $(this).data('id');
      $.get("/tracks/" + id, {}, function(data) {
        var list;
        list = Mustache.to_html(template, data);
        return $("#tracks-" + id).html(list);
      });
      return false;
    });
  });

}).call(this);
