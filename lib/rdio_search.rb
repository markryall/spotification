require 'rdio'

module RdioSearch
  def rdio
    Rdio.new [ENV['RDIO_CONSUMER_KEY'], ENV['RDIO_CONSUMER_SECRET']],
      [ENV['RDIO_CLIENT_KEY'], ENV['RDIO_CLIENT_SECRET']]
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
end