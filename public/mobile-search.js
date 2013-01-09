(function() {

  $(function() {
    var show_albums, show_artists, show_tracks;
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
    $('#search-tracks-form').submit(function() {
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
    show_albums = function(data) {
      var content, queue_album, template;
      template = "<p>{{title}}</p>\n<ul id=\"albums-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#albums}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}}</h3>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n        <p class=\"ui-li-desc\">{{date}} - {{count}} tracks - {{duration}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-album-id=\"{{id}}\">add</a>\n    </li>\n  {{/albums}}\n</ul>";
      queue_album = function() {
        var remove;
        remove = $(this).parent();
        return $.post('/api/enqueue/album', {
          id: $(this).data('album-id'),
          success: function() {
            return remove.slideUp();
          }
        });
      };
      content = Mustache.to_html(template, data);
      $('#albums .albums-content').html(content);
      $.mobile.changePage('#albums');
      $('#albums-list').listview();
      return $('#albums-list a.plus').click(queue_album);
    };
    $('#search-albums-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/albums', {
        criteria: $('#search-albums-criteria').val()
      }, function(data) {
        $.mobile.loading('hide');
        return show_albums({
          albums: data.albums,
          title: "" + data.info.num_results + " albums"
        });
      });
      return false;
    });
    show_artists = function(data) {
      var content, template;
      template = "<p>{{title}}</p>\n<ul id=\"albums-list\" data-role=\"listview\">\n  {{#artists}}\n    <li>\n      <a href=\"#\" data-track-id=\"{{id}}\">{{name}}</a>\n    </li>\n  {{/artists}}\n</ul>";
      content = Mustache.to_html(template, data);
      $('#artists .artists-content').html(content);
      $.mobile.changePage('#artists');
      return $('#artists-list').listview();
    };
    return $('#search-artists-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/artists', {
        criteria: $('#search-artists-criteria').val()
      }, function(data) {
        $.mobile.loading('hide');
        return show_artists({
          artists: data.artists,
          title: "" + data.info.num_results + " artists"
        });
      });
      return false;
    });
  });

}).call(this);
