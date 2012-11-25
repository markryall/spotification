(function() {

  $(function() {
    return $('.enqueue').click(function() {
      return $.post('/track', {
        track: {
          id: $(this).data('id'),
          name: $(this).data('name'),
          album: $(this).data('album'),
          artists: $(this).data('album')
        }
      });
    });
  });

}).call(this);
