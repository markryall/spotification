(function() {

  $(function() {
    var enqueueTrackClickHandler, template;
    template = "<table class=\"table table-hover\">\n  <tbody>\n  {{#tracks}}\n    <tr>\n      <td>{{name}} {{duration}}</td>\n      <td><a class=\"enqueue-track\" data-id=\"{{id}}\" href=\"#\"><i class=\"icon-plus-sign\"></i></a></td>\n    </td>\n  {{/tracks}}\n  <tbody>\n</table>";
    enqueueTrackClickHandler = function() {
      hideMessage();
      $.post('/api/enqueue/track', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("" + data.name + " added to queue");
      });
      return false;
    };
    $('.enqueue-album').click(function() {
      hideMessage();
      $.post('/api/enqueue/album', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("" + data.tracks + " tracks queued");
      });
      return false;
    });
    $('.tracks').click(function() {
      var id;
      hideMessage();
      id = $(this).data('id');
      $.get("/api/album/" + id, {}, function(data) {
        var list;
        showMessage("" + data.tracks.length + " tracks retrieved");
        list = Mustache.to_html(template, data);
        $("#tracks-" + id).html(list);
        return $("#tracks-" + id + " .enqueue-track").click(enqueueTrackClickHandler);
      });
      return false;
    });
    return $('.enqueue-track').click(enqueueTrackClickHandler);
  });

}).call(this);
