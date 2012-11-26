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
      spotify_available? track['album']['availability']['territories']
    end
  end

  def spotify_albums_matching criteria
    response = HTTParty.get "http://ws.spotify.com/search/1/album.json?q=#{CGI.escape criteria}"
    response['albums'].find_all do |album|
      spotify_available? album['availability']['territories']
    end
  end

  def spotify_available? territories
    !(territories.split & ['worldwide', ENV['SPOTIFY_TERRITORY']]).empty?
  end
end