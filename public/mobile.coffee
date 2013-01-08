$('div').live 'pagehide', (event, ui) ->
  console.debug "Now on page #{$(ui.nextPage).attr 'id'}"