(function() {

  $(function() {
    var enqueueTrackClickHandler, template;
    template = "<table class=\"table table-hover\">\n  <tbody>\n  {{#tracks}}\n    <tr>\n      <td>{{name}}</td>\n      <td><a class=\"enqueue-track\" data-id=\"{{id}}\" href=\"#\"><i class=\"icon-plus-sign\"></i></a></td>\n    </td>\n  {{/tracks}}\n  <tbody>\n</table>";
    enqueueTrackClickHandler = function() {
      hideMessage();
      $.post('/track', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("" + data.name + " added to queue");
      });
      return false;
    };
    $('.enqueue-album').click(function() {
      hideMessage();
      $.post('/album', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("" + data.tracks + " tracks queued");
      });
      return false;
    });
    $('.tracks').click(function() {
      var id;
      id = $(this).data('id');
      $.get("/tracks/" + id, {}, function(data) {
        var list;
        list = Mustache.to_html(template, data);
        $("#tracks-" + id).html(list);
        return $("#tracks-" + id + " .enqueue-track").click(enqueueTrackClickHandler);
      });
      return false;
    });
    return $('.enqueue-track').click(enqueueTrackClickHandler);
  });

}).call(this);
