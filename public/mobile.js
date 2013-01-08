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
        $('#queue-tracks').html(list);
        $('#queue-list').listview();
        return $('#queue-tracks a.remove').click(remove_queued_track);
      });
    };
    $('div').live('pagehide', function(event, ui) {
      switch ($(ui.nextPage).attr('id')) {
        case 'queue':
          return load_queue();
      }
    });
    $('#volume-slider').slider();
    $('#volume-slider').on('slidestop', function() {
      return $.post('/volume', {
        percentage: $('#volume-slider').val()
      }, function(data) {
        return $('#volume-slider').val(data.percentage);
      });
    });
    return load_queue();
  });

}).call(this);
