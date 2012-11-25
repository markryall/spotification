require 'httparty'
require 'cgi'

unless ENV['SPOTIFY_TERRITORY']
  puts 'please set SPOTIFY_TERRITORY (eg. AU)'
  exit 1
end

module Spotify
  def spotify_tracks_matching criteria
    response = HTTParty.get "http://ws.spotify.com/search/1/track.json?q=#{CGI.escape criteria}"
    response['tracks'].find_all do |track|
      track['album']['availability']['territories'].split.include? ENV['SPOTIFY_TERRITORY']
    end
  end
end