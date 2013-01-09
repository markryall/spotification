(function() {

  $(function() {
    $('#volume-slider').slider();
    return $('#volume-slider').on('slidestop', function() {
      return $.post('/volume', {
        percentage: $('#volume-slider').val()
      }, function(data) {
        return $('#volume-slider').val(data.percentage);
      });
    });
  });

}).call(this);