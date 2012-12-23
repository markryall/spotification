require 'httparty'
require 'cgi'

unless ENV['SPOTIFY_TERRITORY']
  puts 'please set SPOTIFY_TERRITORY (eg. AU)'
  exit 1
end

module Spotify
  def spotify_tracks_matching criteria
    tracks = []
    results, info = spotify_search 'track', criteria
    results.each do |track|
      if spotify_available? track['album']['availability']['territories']
        tracks << {
          'id' => track['href'].split(':').last,
          'name' => track['name'],
          'album' => track['album']['name'],
          'artists' => track['artists'].map{|a| a['name']}.join(',')
        }
      end
    end
    return tracks, info
  end

  def spotify_albums_matching criteria
    albums = []
    results, info = spotify_search 'album', criteria
    results.each do |album|
      if spotify_available? album['availability']['territories']
        albums << {
          'id' => album['href'].split(':').last,
          'name' => album['name'],
          'artists' => album['artists'].map{|a| a['name']}.join(',')
        }
      end
    end
    return albums, info
  end

  def spotify_artists_matching criteria
    artists = []
    results, info = spotify_search 'artist', criteria
    results.each do |artist|
      artists << {
        'id' => artist['href'].split(':').last,
        'name' => artist['name']
      }
    end
    return artists, info
  end

  def spotify_artist id
    result = spotify_lookup "spotify:artist:#{id}", 'album'
    return {} unless result and result['artist']
    artist = result['artist']
    albums = []
    artist['albums'].each do |album|
      if spotify_available? album['album']['availability']['territories']
        albums << {
          'id' => album['album']['href'].split(':').last,
          'name' => album['album']['name']
        }
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
        'id' => track['href'].split(':').last,
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
    result = HTTParty.get("http://ws.spotify.com/search/1/#{entity}.json?q=#{CGI.escape criteria}")
    return result["#{entity}s"], result['info']
  end

  def spotify_lookup id, *extras
    HTTParty.get("http://ws.spotify.com/lookup/1/.json?uri=#{id}&extras=#{extras.join ','}")
  end
end