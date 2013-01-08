(function() {

  $(function() {
    return $('#search-tracks-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/tracks', {
        criteria: $('#search-tracks').val()
      }, function(data) {
        console.debug(data);
        $.mobile.loading('hide');
        return $.mobile.changePage('#tracks');
      });
      return false;
    });
  });

}).call(this);
