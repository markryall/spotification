(function() {

  $(function() {
    var queue_track, template;
    template = "<p>{{info.num_results}} tracks</p>\n<ul id=\"tracks-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#tracks}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}} ({{duration}})</h3>\n        <p class=\"ui-li-desc\">{{album}}</p>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-track-id=\"{{id}}\">remove</a>\n    </li>\n  {{/tracks}}\n</ul>";
    queue_track = function() {
      var remove;
      remove = $(this).parent();
      return $.post('/api/enqueue/track', {
        id: $(this).data('track-id'),
        success: function() {
          return remove.slideUp();
        }
      });
    };
    return $('#search-tracks-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/tracks', {
        criteria: $('#search-tracks-criteria').val()
      }, function(data) {
        var content;
        content = Mustache.to_html(template, data);
        $('#tracks .tracks-content').html(content);
        $.mobile.loading('hide');
        $.mobile.changePage('#tracks');
        $('#tracks-list').listview();
        return $('#tracks-list a.plus').click(queue_track);
      });
      return false;
    });
  });

}).call(this);
