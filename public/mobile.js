(function() {

  $(function() {
    $('div').live('pagehide', function(event, ui) {
      return console.debug("Now on page " + ($(ui.nextPage).attr('id')));
    });
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
