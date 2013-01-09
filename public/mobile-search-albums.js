(function() {

  $(function() {
    var queue_album, template;
    template = "<p>{{info.num_results}} albums</p>\n<ul id=\"albums-list\" data-role=\"listview\" data-split-icon=\"plus\" data-split-theme=\"d\">\n  {{#albums}}\n    <li>\n      <a href=\"#\">\n        <img src=\"{{icon}}\" class=\"ui-li-thumb\">\n        <h3 class=\"ui-li-heading\">{{name}}</h3>\n        <p class=\"ui-li-desc\">{{artists}}</p>\n        <p class=\"ui-li-desc\">{{date}} - {{count}} tracks - {{duration}}</p>\n      </a>\n      <a href=\"#\" class='plus' data-album-id=\"{{id}}\">add</a>\n    </li>\n  {{/albums}}\n</ul>";
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
        $('#albums-list').listview();
        return $('#albums-list a.plus').click(queue_album);
      });
      return false;
    });
  });

}).call(this);
