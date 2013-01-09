(function() {

  $(function() {
    var template;
    template = "<p>{{info.num_results}} artists</p>\n<ul id=\"albums-list\" data-role=\"listview\">\n  {{#artists}}\n    <li>\n      <a href=\"#\" data-track-id=\"{{id}}\">{{name}}</a>\n    </li>\n  {{/artists}}\n</ul>";
    return $('#search-artists-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/artists', {
        criteria: $('#search-artists-criteria').val()
      }, function(data) {
        var content;
        $.mobile.loading('hide');
        content = Mustache.to_html(template, data);
        $('#artists .artists-content').html(content);
        $.mobile.changePage('#artists');
        return $('#artists-list').listview();
      });
      return false;
    });
  });

}).call(this);
