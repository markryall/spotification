(function() {

  $(function() {
    return $('.dequeue').click(function() {
      var remove;
      remove = $(this).parent().parent().parent();
      $.post('/dequeue', {
        id: $(this).data('id'),
        success: function() {
          return remove.slideUp();
        }
      });
      return false;
    });
  });

}).call(this);
