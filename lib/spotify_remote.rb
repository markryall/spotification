module SpotifyRemote
  def player_state
    spotify_command "player state"
  end

  def play id
    spotify_command "open location \"#{id}\""
  end

  def volume
    `osascript -e 'output volume of (get volume settings)'`.chomp
  end

  def volume= value
    `osascript -e 'set volume output volume #{value}'`
  end

  def spotify_command command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'"
    `#{full_command}`.chomp
  end
end