(function() {

  $(function() {
    var load_lastfm, template;
    template = "<ul id=\"lastfm-list\" data-role=\"listview\">\n  {{#tracks}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{image}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}}</h3>\n        <p class=\"ui-li-desc\">{{album}}</p>\n        <p class=\"ui-li-desc\">{{artist}}</p>\n        <p class=\"ui-li-desc\">{{when}}</p>\n      </a>\n    </li>\n  {{/tracks}}\n</ul>";
    load_lastfm = function() {
      return $.get('/api/lastfm', {}, function(data) {
        var list;
        list = Mustache.to_html(template, data);
        $('#lastfm .lastfm-content').html(list);
        return $('#lastfm-list').listview();
      });
    };
    return $('div').live('pagehide', function(event, ui) {
      if ($(ui.nextPage).attr('id') === 'lastfm') {
        return load_lastfm();
      }
    });
  });

}).call(this);
