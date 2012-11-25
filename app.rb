require 'sinatra'
require 'slim'
require 'httparty'

get '/lastfm/:user' do |user|
  tracks = HTTParty.get "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&nowplaying=true&user=#{user}&api_key=#{ENV['LASTFM_API_KEY']}&format=json"
  slim :index, locals: {tracks: tracks['recenttracks']['track']}
end

get '/search' do
  slim :search
end

post '/search' do
  slim :results
end