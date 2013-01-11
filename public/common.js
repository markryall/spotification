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
      $.post('/api/volume/down', {
        id: $(this).data('level')
      }, function(data) {
        return $('.volume').text(data.percentage);
      });
      return false;
    });
    $('.volume_up').click(function() {
      $.post('/api/volume/up', {
        id: $(this).data('level')
      }, function(data) {
        return $('.volume').text(data.percentage);
      });
      return false;
    });
    $('.rewind').click(function() {
      $.post('/api/player/rewind');
      return false;
    });
    $('.playpause').click(function() {
      hideMessage();
      $.post('/api/player/playpause', {}, function(data) {
        return showMessage("Player is now " + data.state);
      });
      return false;
    });
    return $('.fastforward').click(function() {
      $.post('/api/player/fastforward');
      return false;
    });
  });

}).call(this);
