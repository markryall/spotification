(function() {

  $(function() {
    var template;
    template = "<p>{{info.num_results}} tracks</p>\n<ul id=\"tracks-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#tracks}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}} ({{duration}})</h3>\n        <p class=\"ui-li-desc\">{{album}}</p>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-track-index=\"{{id}}\">remove</a>\n    </li>\n  {{/tracks}}\n</ul>";
    return $('#search-tracks-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/tracks', {
        criteria: $('#search-tracks').val()
      }, function(data) {
        var content;
        content = Mustache.to_html(template, data);
        $('#tracks .tracks-content').html(content);
        $('#tracks-list').listview();
        $.mobile.loading('hide');
        return $.mobile.changePage('#tracks');
      });
      return false;
    });
  });

}).call(this);
