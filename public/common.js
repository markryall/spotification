(function() {

  $(function() {
    $('.volume_down').click(function() {
      $.post('/volume/down', {
        id: $(this).data('level')
      }, function(data) {
        return $('a.volume').text(data.percentage);
      });
      return false;
    });
    return $('.volume_up').click(function() {
      $.post('/volume/up', {
        id: $(this).data('level')
      }, function(data) {
        return $('a.volume').text(data.percentage);
      });
      return false;
    });
  });

}).call(this);
