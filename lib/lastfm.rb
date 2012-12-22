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
    tracks
  end

  def get_url url
    HTTParty.get url
  end
end