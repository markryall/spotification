(function() {

  $(function() {
    return $('.enqueue').click(function() {
      $.post('/album', {
        id: $(this).data('id')
      });
      return false;
    });
  });

}).call(this);
