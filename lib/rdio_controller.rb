module RdioController
  def player_state
    spotify_command "get the player state"
  end

  def play id
    spotify_command "play source \"#{id}\""
  end

  def playpause
    spotify_command "playpause"
  end

  def rewind
    spotify_command "previous track"
  end

  def fastforward
    spotify_command "next track"
  end

  def ready_for_next_track?
    player_state == 'paused'
  end

  def spotify_command command
    full_command = "osascript -e 'tell application \"Rdio\" to #{command}'"
    `#{full_command}`.chomp
  end
end