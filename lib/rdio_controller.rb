module RdioController
  def player_state
    tell_rdio_to "get the player state"
  end

  def play id
    tell_rdio_to "play source \"#{id}\""
  end

  def playpause
    tell_rdio_to "playpause"
  end

  def rewind
    tell_rdio_to "previous track"
  end

  def fastforward
    tell_rdio_to "next track"
  end

  def ready_for_next_track?
    player_state == 'paused'
  end

  def tell_rdio_to command
    full_command = "osascript -e 'tell application \"Rdio\" to #{command}'"
    `#{full_command}`.chomp
  end
end