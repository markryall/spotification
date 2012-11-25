require 'httparty'
require 'cgi'

module Spotify
  def spotify_tracks_matching criteria
    response = HTTParty.get "http://ws.spotify.com/search/1/track.json?q=#{CGI.escape criteria}"
    response['tracks']
  end
end