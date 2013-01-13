require 'httparty'
require 'cgi'

unless ENV['SPOTIFY_TERRITORY']
  puts 'please set SPOTIFY_TERRITORY (eg. AU)'
  exit 1
end

module SpotifySearch
  def extract_id hash
    hash['href'].split(':').last
  end

  def extract_artist hash
    return hash['artist'] if hash['artist']
    hash['artists'].map{|a| a['name']}.join(',')
  end

  def to_artist hash
    {
      'id'   => extract_id(hash),
      'name' => hash['name']
    }
  end

  def to_album hash, count=0
    {
      'id'      => extract_id(hash),
      'name'    => hash['name'],
      'artists' => extract_artist(hash),
      'icon'    => '',
      'date'    => hash['released'] ? hash['released'] : '????',
      'count'   => count,
      'duration' => to_duration(hash)
    }
  end

  def to_track hash, album_name=nil
    {
      'id'       => extract_id(hash),
      'name'     => hash['name'],
      'album'    => album_name ? album_name : hash['album']['name'],
      'artists'  => extract_artist(hash),
      'duration' => to_duration(hash),
      'icon'     => ''
    }
  end

  def to_duration hash
    duration = hash['length'].to_i
    "%02d:%02d" % [duration/60,duration%60]
  end

  def tracks_matching criteria
    tracks = []
    results, info = spotify_search 'track', criteria
    results.each do |track|
      tracks << to_track(track) if spotify_available? track['album']['availability']['territories']
    end
    return tracks, info
  end

  def albums_matching criteria
    albums = []
    results, info = spotify_search 'album', criteria
    results.each do |album|
      albums << to_album(album) if spotify_available? album['availability']['territories']
    end
    return albums, info
  end

  def artists_matching criteria
    artists = []
    results, info = spotify_search 'artist', criteria
    results.each do |artist|
      artists << to_artist(artist)
    end
    return artists, info
  end

  def artist_info id
    result = spotify_lookup "spotify:artist:#{id}", 'albumdetail'
    return {} unless result and result['artist']
    artist = to_artist result['artist']
    albums = []
    result['artist']['albums'].each do |album|
      albums << to_album(album['album']) if spotify_available? album['album']['availability']['territories']
    end
    artist['albums'] = albums
    artist
  end

  def album_info id
    result = spotify_lookup "spotify:album:#{id}", 'trackdetail'
    return {} unless result and result['album']
    album = to_album result['album'], result['album']['tracks'].count
    tracks = []
    result['album']['tracks'].each do |track|
      tracks << to_track(track, result['album']['name'])
    end
    album['tracks'] = tracks
    album
  end

  def track_info id
    result = spotify_lookup "spotify:track:#{id}"
    return {} unless result and result['track']
    to_track result['track']
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