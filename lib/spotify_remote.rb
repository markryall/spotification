module SpotifyRemote
  def player_state
    spotify_command "player state"
  end

  def play id
    spotify_command "open location \"#{id}\""
    spotify_command "play"
  end

  def spotify_command command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'"
    `#{full_command}`.chomp
  end
end