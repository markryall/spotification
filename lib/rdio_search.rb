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