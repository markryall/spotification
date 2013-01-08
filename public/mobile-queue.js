(function() {

  $(function() {
    var load_queue, queue_template, remove_queued_track;
    queue_template = "<ul id=\"queue-list\" data-role=\"listview\" data-split-icon=\"delete\" data-split-theme=\"d\">\n  {{#tracks}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}} ({{duration}})</h3>\n        <p class=\"ui-li-desc\">{{album}}</p>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n      </a>\n      <a href=\"#\" class='remove' data-track-index=\"{{index}}\">remove</a>\n    </li>\n  {{/tracks}}\n</ul>";
    remove_queued_track = function() {
      var remove;
      remove = $(this).parent();
      return $.post('/dequeue', {
        id: $(this).data('track-index'),
        success: function() {
          return remove.slideUp();
        }
      });
    };
    load_queue = function() {
      return $.get('/api/queue', {}, function(data) {
        var list;
        list = Mustache.to_html(queue_template, data);
        $('#queue .queue-content').html(list);
        $('#queue-list').listview();
        return $('#queue-list a.remove').click(remove_queued_track);
      });
    };
    return $('div').live('pagehide', function(event, ui) {
      if ($(ui.nextPage).attr('id') === 'queue') {
        return load_queue();
      }
    });
  });

}).call(this);
