(function() {

  $(function() {
    var show_tracks;
    show_tracks = function(data) {
      var content, queue_track, template;
      template = "<p>{{title}}</p>\n<ul id=\"tracks-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#tracks}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}} ({{duration}})</h3>\n        <p class=\"ui-li-desc\">{{album}}</p>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-track-id=\"{{id}}\">remove</a>\n    </li>\n  {{/tracks}}\n</ul>";
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
      content = Mustache.to_html(template, data);
      $('#tracks .tracks-content').html(content);
      $.mobile.changePage('#tracks');
      $('#tracks-list').listview();
      return $('#tracks-list a.plus').click(queue_track);
    };
    return $('#search-tracks-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/tracks', {
        criteria: $('#search-tracks-criteria').val()
      }, function(data) {
        $.mobile.loading('hide');
        return show_tracks({
          tracks: data.tracks,
          title: "" + data.info.num_results + " tracks"
        });
      });
      return false;
    });
  });

}).call(this);
