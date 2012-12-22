module SpotifyRemote
  def player_state
    spotify_command "player state"
  end

  def play id
    spotify_command "open location \"#{id}\""
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

  def spotify_command command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'"
    `#{full_command}`.chomp
  end
end