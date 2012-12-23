(function() {

  window.showMessage = function(message) {
    $('.message').text(message);
    return $('.message').removeClass('hidden');
  };

  window.hideMessage = function() {
    return $('.message').addClass('hidden');
  };

  $(function() {
    $('.volume_down').click(function() {
      $.post('/volume/down', {
        id: $(this).data('level')
      }, function(data) {
        return $('.volume').text(data.percentage);
      });
      return false;
    });
    $('.volume_up').click(function() {
      $.post('/volume/up', {
        id: $(this).data('level')
      }, function(data) {
        return $('.volume').text(data.percentage);
      });
      return false;
    });
    $('.rewind').click(function() {
      $.post('/player/rewind');
      return false;
    });
    $('.playpause').click(function() {
      $.post('/player/playpause');
      return false;
    });
    return $('.fastforward').click(function() {
      $.post('/player/fastforward');
      return false;
    });
  });

}).call(this);
