require 'httparty'
require 'cgi'

unless ENV['SPOTIFY_TERRITORY']
  puts 'please set SPOTIFY_TERRITORY (eg. AU)'
  exit 1
end

module Spotify
  def spotify_tracks_matching criteria
    spotify_search('track', criteria).find_all do |track|
      spotify_available? track['album']['availability']['territories']
    end
  end

  def spotify_albums_matching criteria
    spotify_search('album', criteria).find_all do |album|
      spotify_available? album['availability']['territories']
    end
  end

  def spotify_artist_matching criteria
    spotify_search 'artist', criteria
  end

  def spotify_artist id
    artist = spotify_lookup(id, 'album')['artist']
    albums = []
    artist['albums'].each do |album|
      if spotify_available? album['album']['availability']['territories']
        albums << album['album']
      end
    end
    artist['albums'] = albums
    artist
  end

  def spotify_album id
    spotify_lookup(id, 'track')['album']
  end

  def spotify_available? territories
    !(territories.split & ['worldwide', ENV['SPOTIFY_TERRITORY']]).empty?
  end

  def spotify_search entity, criteria
    HTTParty.get("http://ws.spotify.com/search/1/#{entity}.json?q=#{CGI.escape criteria}")["#{entity}s"]
  end

  def spotify_lookup id, *extras
    HTTParty.get("http://ws.spotify.com/lookup/1/.json?uri=#{id}&extras=#{extras.join ','}")
  end

  def volume
    `osascript -e 'output volume of (get volume settings)'`.chomp.to_i
  end

  def volume= value
    `osascript -e 'set volume output volume #{value}'`
  end
end