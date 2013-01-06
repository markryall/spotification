require 'rdio'

module RdioSearch
  def rdio
    Rdio.new [ENV['RDIO_CONSUMER_KEY'], ENV['RDIO_CONSUMER_SECRET']],
      [ENV['RDIO_CLIENT_KEY'], ENV['RDIO_CLIENT_SECRET']]
  end

  def albums_matching criteria
    result = rdio.call 'search', 'query' => criteria, 'types' => 'album'
    albums = result['result']['results'].map do |album|
      {
        'id' => album['key'],
        'name' => album['name'],
        'artists' => album['artist']
      }
    end
    return albums, {'num_results' => result['result']['number_results']}
  end

  def album_info id
    result = rdio.call 'get', 'keys' => id, 'extras' => 'tracks'
    album_result = result['result'][id]
    album = {
      'id' => id,
      'name' => album_result['name'],
      'artist' => album_result['artist']
    }
    album['tracks'] = album_result['tracks'].map do |track|
      {
        'id' => track['key'],
        'name' => track['name'],
        'album' => album_result['name'],
        'artists' => album_result['artist']
      }
    end
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