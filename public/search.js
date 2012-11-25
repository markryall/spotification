(function() {

  $(function() {
    return $('.enqueue').click(function() {
      $.post('/track', {
        track: {
          id: $(this).data('id'),
          name: $(this).data('name'),
          album: $(this).data('album'),
          artists: $(this).data('album')
        }
      });
      return false;
    });
  });

}).call(this);
