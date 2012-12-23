require 'httparty'
require 'cgi'

unless ENV['SPOTIFY_TERRITORY']
  puts 'please set SPOTIFY_TERRITORY (eg. AU)'
  exit 1
end

module Spotify
  def spotify_tracks_matching criteria
    tracks = []
    spotify_search('track', criteria).each do |track|
      if spotify_available? track['album']['availability']['territories']
        tracks << {
          'id' => track['href'],
          'name' => track['name'],
          'album' => track['album']['name'],
          'artists' => track['artists'].map{|a| a['name']}.join(',')
        }
      end
    end
    tracks
  end

  def spotify_albums_matching criteria
    albums = []
    spotify_search('album', criteria).each do |album|
      if spotify_available? album['availability']['territories']
        albums << {
          'id' => album['href'].split(':').last,
          'name' => album['name'],
          'artists' => album['artists'].map{|a| a['name']}.join(',')
        }
      end
    end
    albums
  end

  def spotify_artists_matching criteria
    artists = []
    spotify_search('artist', criteria).each do |artist|
      artists << {
        'id' => artist['href'],
        'name' => artist['name']
      }
    end
    artists
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
    result = spotify_lookup "spotify:album:#{id}", 'track'
    return {} unless result and result['album']
    album = {
      'name' => result['album']['name'],
      'tracks' => []
    }
    result['album']['tracks'].each do |track|
      album['tracks'] << {
        'id' => track['href'],
        'name' => track['name'],
        'album' => album['name'],
        'artists' => track['artists'].map{|a| a['name']}.join(',')
      }
    end
    album
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