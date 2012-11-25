(function() {

  $(function() {
    return $('.enqueue').click(function() {
      return $.post('/track', {
        id: $(this).data('id')
      });
    });
  });

}).call(this);
