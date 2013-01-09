(function() {

  $(function() {
    return $('#search-albums-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/albums', {
        criteria: $('#search-albums-criteria').val()
      }, function(data) {
        $.mobile.loading('hide');
        return console.log(data);
      });
      return false;
    });
  });

}).call(this);
