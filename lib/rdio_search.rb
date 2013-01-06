require 'rdio'

module RdioSearch
  def rdio
    Rdio.new [ENV['RDIO_CONSUMER_KEY'], ENV['RDIO_CONSUMER_SECRET']],
      [ENV['RDIO_CLIENT_KEY'], ENV['RDIO_CLIENT_SECRET']]
  end

  def to_album hash
    {
      'id'      => hash['key'],
      'name'    => hash['name'],
      'artists' => hash['artist']
    }
  end

  def to_track hash
    {
      'id'      => hash['key'],
      'name'    => hash['name'],
      'album'   => hash['album'],
      'artists' => hash['artist']
    }
  end

  def rdio_search criteria, type
    result = rdio.call 'search', 'query' => criteria, 'types' => type
    result['result']
  end

  def rdio_get id, extras=nil
    result = rdio.call 'get', 'keys' => id, 'extras' => extras
    result['result'][id]
  end

  def albums_matching criteria
    result = rdio_search criteria, 'album'
    albums = result['results'].map { |album| to_album album }
    return albums, {'num_results' => result['number_results']}
  end

  def album_info id
    album_result = rdio_get id, 'tracks'
    album = to_album album_result
    album['tracks'] = album_result['tracks'].map { |track| to_track track }
    album
  end

  def artists_matching criteria
    result = rdio.call 'search', 'query' => criteria, 'types' => 'artist'
    artists = result['result']['results'].map do |artist|
      {
        'id' => artist['key'],
        'name' => artist['name']
      }
    end
    return artists, {'num_results' => result['result']['number_results']}
  end

  def artist_info id
    result = rdio.call 'get', 'keys' => id
    artist_result = result['result'][id]
    artist = {
      'id' => id,
      'name' => artist_result['name']
    }
    result = rdio.call 'getAlbumsForArtist', 'artist' => id
    artist['albums'] = result['result'].map do |album|
      {
        'id' => album['key'],
        'name' => album['name']
      }
    end
    artist
  end

  def tracks_matching criteria
    result = rdio.call 'search', 'query' => criteria, 'types' => 'track'
    tracks = result['result']['results'].map do |track|
      {
        'id' => track['key'],
        'name' => track['name'],
        'album' => track['album'],
        'artists' => track['artist']
      }
    end
    return tracks, {'num_results' => result['result']['number_results']}
  end

  def track_info id
    result = rdio.call 'get', 'keys' => id
    track = result['result'][id]
    {
        'id' => id,
        'name' => track['name'],
        'album' => track['album'],
        'artists' => track['artist'],
        'duration' => track['duration'],
        'icon' => track['icon']
    }
  end
end