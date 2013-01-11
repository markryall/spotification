(function() {

  $(function() {
    $('#volume-slider').slider();
    $('#volume-slider').on('slidestop', function() {
      return $.post('/api/volume', {
        percentage: $('#volume-slider').val()
      }, function(data) {
        return $('#volume-slider').val(data.percentage);
      });
    });
    $('#rewind').click(function() {
      $.post('/api/player/rewind');
      return false;
    });
    $('#playpause').click(function() {
      $.post('/api/player/playpause');
      return false;
    });
    return $('#fastforward').click(function() {
      $.post('/api/player/fastforward');
      return false;
    });
  });

}).call(this);
