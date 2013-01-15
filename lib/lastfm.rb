require 'httparty'

unless ENV['LASTFM_API_KEY']
  puts 'please set LASTFM_API_KEY'
  exit 1
end

module Lastfm
  def recent_lastfm_tracks_for user
    response = get_url "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&nowplaying=true&user=#{user}&api_key=#{ENV['LASTFM_API_KEY']}&format=json"
    tracks = []
    tracks = response['recenttracks']['track'] if response && response['recenttracks'] && response['recenttracks']['track']
    now = Time.now.to_i
    tracks.map do |track|
      t = {
        'name' => track['name'],
        'artist' => track['artist']['#text'],
        'album' => track['album']['#text'],
        'when' => dotiw(now-track['date']['uts'].to_i)
      }
      track['image'].each do |image|
        t['image'] = image['#text'] if image['size'] = 'large'
      end
      t
    end
  end

  def dotiw seconds
    return "#{seconds} seconds ago" if seconds < 60
    minutes = seconds / 60
    return "#{minutes} minutes ago" if minutes < 60
    hours = minutes / 60
    return "#{hours} hours ago" if hours < 24
    days = hours / 24
    "#{days} days ago"
  end

  def get_url url
    HTTParty.get url
  end
end