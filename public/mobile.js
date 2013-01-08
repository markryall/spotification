(function() {

  $(function() {
    var load_queue, queue_template;
    queue_template = "<ul id=\"queue-list\" data-role=\"listview\">\n  {{#tracks}}\n    <li>\n      <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n      <h3 class=\"ui-li-heading\">{{name}} ({{duration}})</h3>\n      <p class=\"ui-li-desc\">{{album}}</p>\n      <p class=\"ui-li-desc\">{{artists}}</p>\n    </li>\n  {{/tracks}}\n</ul>";
    load_queue = function() {
      return $.get('/api/queue', {}, function(data) {
        var list;
        list = Mustache.to_html(queue_template, data);
        $('#queue-tracks').html(list);
        return $('#queue-list').listview();
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
