require 'httparty'

unless ENV['LASTFM_API_KEY']
  puts 'please set LASTFM_API_KEY'
  exit 1
end

module Lastfm
  def recent_lastfm_tracks_for user
    response =  HTTParty.get "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&nowplaying=true&user=#{user}&api_key=#{ENV['LASTFM_API_KEY']}&format=json"
    response['recenttracks']['track']
  end
end