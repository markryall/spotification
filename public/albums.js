(function() {

  $(function() {
    var handleEnqueueClick, template;
    template = "<table class=\"table table-hover\">\n  <tbody>\n  {{#tracks}}\n    <tr>\n      <td>{{name}}</td>\n      <td><a class=\"enqueue\" data-id=\"{{id}}\" href=\"#\"><i class=\"icon-plus-sign\"></i></a></td>\n    </td>\n  {{/tracks}}\n  <tbody>\n</table>";
    handleEnqueueClick = function() {
      hideMessage();
      $.post('/track', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("Track added to queue");
      });
      return false;
    };
    $('.enqueue').click(function() {
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
        return $("#tracks-" + id + " .enqueue").click(handleEnqueueClick);
      });
      return false;
    });
    return $('.enqueue').click(handleEnqueueClick);
  });

}).call(this);
