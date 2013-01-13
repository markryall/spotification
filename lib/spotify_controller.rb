module SpotifyController
  def player_state
    tell_spotify_to "player state"
  end

  def play id
    tell_spotify_to "open location \"spotify:track:#{id}\""
  end

  def playpause
    tell_spotify_to "playpause"
  end

  def rewind
    tell_spotify_to "previous track"
  end

  def fastforward
    tell_spotify_to "next track"
  end

  def ready_for_next_track?
    player_state == 'stopped'
  end

  def tell_spotify_to command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'"
    `#{full_command}`.chomp
  end
end