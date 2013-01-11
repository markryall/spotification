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
      var content, queue_album, show_album, template;
      template = "<p>{{title}}</p>\n<ul id=\"albums-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#albums}}\n    <li>\n      <a href=\"#\" class='tracks' data-id=\"{{id}}\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}}</h3>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n        <p class=\"ui-li-desc\">{{date}} - {{count}} tracks - {{duration}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-id=\"{{id}}\">add</a>\n    </li>\n  {{/albums}}\n</ul>";
      queue_album = function() {
        var remove;
        remove = $(this).parent();
        return $.post('/api/enqueue/album', {
          id: $(this).data('id'),
          success: function() {
            return remove.slideUp();
          }
        });
      };
      show_album = function() {
        return $.get("/api/album/" + ($(this).data('id')), function(data) {
          console.log(data);
          return show_tracks({
            tracks: data.tracks,
            title: data.name
          });
        });
      };
      content = Mustache.to_html(template, data);
      $('#albums .albums-content').html(content);
      $.mobile.changePage('#albums');
      $('#albums-list').listview();
      $('#albums-list a.plus').click(queue_album);
      return $('#albums-list a.tracks').click(show_album);
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
      var content, show_artist, template;
      template = "<p>{{title}}</p>\n<ul id=\"artists-list\" data-role=\"listview\">\n  {{#artists}}\n    <li>\n      <a href=\"#\" data-id=\"{{id}}\">{{name}}</a>\n    </li>\n  {{/artists}}\n</ul>";
      show_artist = function() {
        return $.get("/api/artist/" + ($(this).data('id')), function(data) {
          console.log(data);
          return show_albums({
            albums: data.albums,
            title: data.name
          });
        });
      };
      content = Mustache.to_html(template, data);
      $('#artists .artists-content').html(content);
      $.mobile.changePage('#artists');
      $('#artists-list').listview();
      return $('#artists-list a').click(show_artist);
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
