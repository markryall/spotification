require 'rdio'

module RdioSearch
  def rdio
    Rdio.new [ENV['RDIO_CONSUMER_KEY'], ENV['RDIO_CONSUMER_SECRET']],
      [ENV['RDIO_CLIENT_KEY'], ENV['RDIO_CLIENT_SECRET']]
  end

  def rdio_search criteria, type
    result = rdio.call 'search', 'query' => criteria, 'types' => type
    result['result']
  end

  def rdio_get id, extras=nil
    params = { 'keys' => id }
    params['extras'] = extras if extras
    result = rdio.call 'get', params
    result['result'][id]
  end

  def to_artist hash
    {
      'id'   => hash['key'],
      'name' => hash['name']
    }
  end

  def to_duration hash
    duration = hash['duration'].to_i
    "%02d:%02d" % [duration/60,duration%60]
  end

  def to_album hash
    {
      'id'      => hash['key'],
      'name'    => hash['name'],
      'artists' => hash['artist'],
      'icon'    => hash['icon'],
      'date'    => hash['releaseDate'],
      'count'   => hash['trackKeys'].count,
      'duration' => to_duration(hash)
    }
  end

  def to_track hash
    duration = hash['duration'].to_i
    {
      'id'       => hash['key'],
      'name'     => hash['name'],
      'album'    => hash['album'],
      'artists'  => hash['artist'],
      'duration' => to_duration(hash),
      'icon'     => hash['icon']
    }
  end

  def artists_matching criteria
    result = rdio_search criteria, 'artist'
    artists = result['results'].map { |hash| to_artist hash }
    return artists, {'num_results' => result['number_results']}
  end

  def albums_matching criteria
    result = rdio_search criteria, 'album'
    albums = result['results'].map { |hash| to_album hash }
    return albums, {'num_results' => result['number_results']}
  end

  def tracks_matching criteria
    result = rdio_search criteria, 'track'
    tracks = result['results'].map { |hash| to_track hash }
    return tracks, {'num_results' => result['number_results']}
  end

  def artist_info id
    artist_result = id
    artist = to_artist artist_result
    result = rdio.call 'getAlbumsForArtist', 'artist' => id.to_s
    artist['albums'] = result['result'].map { |hash| to_album hash }
    artist
  end

  def album_info id
    album_result = rdio_get id, 'tracks'
    album = to_album album_result
    album['tracks'] = album_result['tracks'].map { |track| to_track track }
    album
  end

  def track_info id
    to_track rdio_get id
  end
end