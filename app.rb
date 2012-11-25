require 'sinatra'
require 'slim'
require 'httparty'
require 'cgi'
require 'sinatra/content_for'

get '/lastfm/:user' do |user|
  tracks = HTTParty.get "http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&nowplaying=true&user=#{user}&api_key=#{ENV['LASTFM_API_KEY']}&format=json"
  slim :index, locals: {tracks: tracks['recenttracks']['track']}
end

get '/tracks' do
  slim :search, locals: {criteria: '', tracks: []}
end

post '/tracks' do
  criteria = params[:criteria]
  results = HTTParty.get "http://ws.spotify.com/search/1/track.json?q=#{CGI.escape criteria}"
  slim :search, locals: {criteria: criteria, tracks: results['tracks']}
end

post '/track' do
  puts params[:id]
end