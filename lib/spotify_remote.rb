module SpotifyRemote
  def player_state
    `osascript -e 'tell application "Spotify" to player state'`.chomp
  end

  def play id
    spotify_command "open location \"#{id}\""
  end

  def spotify_command command
    full_command = "osascript -e 'tell application \"Spotify\" to #{command}'".tap {|c| puts c }
    `#{full_command}`.chomp
  end
end