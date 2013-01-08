(function() {

  $('div').live('pagehide', function(event, ui) {
    return console.debug("Now on page " + ($(ui.nextPage).attr('id')));
  });

}).call(this);
