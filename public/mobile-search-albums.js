(function() {

  $(function() {
    var template;
    template = "<p>{{info.num_results}} albums</p>\n<ul id=\"albums-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#albums}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}}</h3>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n        <p class=\"ui-li-desc\">{{date}} - {{count}} tracks - {{duration}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-track-id=\"{{id}}\">add</a>\n    </li>\n  {{/albums}}\n</ul>";
    return $('#search-albums-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/albums', {
        criteria: $('#search-albums-criteria').val()
      }, function(data) {
        var content;
        $.mobile.loading('hide');
        content = Mustache.to_html(template, data);
        $('#albums .albums-content').html(content);
        $.mobile.changePage('#albums');
        return $('#albums-list').listview();
      });
      return false;
    });
  });

}).call(this);
