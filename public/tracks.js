(function() {

  $(function() {
    return $('.enqueue').on('click', function() {
      hideMessage();
      $.post('/track', {
        id: $(this).data('id')
      }, function(data) {
        return showMessage("Track added to queue");
      });
      return false;
    });
  });

}).call(this);
