(function() {

  $(function() {
    return $('#search-artists-form').submit(function() {
      $.mobile.loading('show');
      $.get('/api/search/artists', {
        criteria: $('#search-artists-criteria').val()
      }, function(data) {
        $.mobile.loading('hide');
        return console.log(data);
      });
      return false;
    });
  });

}).call(this);
