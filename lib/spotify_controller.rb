module SpotifyController
  def player_state
    spotify_command "player state"
  end

  def play id
    spotify_command "open location \"spotify:track:#{id}\""
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
    player_state == 'stopped'
  end

  def spotify_command command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'"
    `#{full_command}`.chomp
  end
end