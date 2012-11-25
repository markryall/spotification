require 'sinatra'
require 'slim'
require 'sinatra/content_for'
require 'lastfm'
require 'spotify'

include Lastfm
include Spotify

get '/lastfm/:user' do |user|
  slim :index, locals: {tracks: recent_lastfm_tracks_for(user) }
end

get '/tracks' do
  slim :search, locals: {criteria: '', tracks: []}
end

post '/tracks' do
  criteria = params[:criteria]
  results =  criteria
  slim :search, locals: {criteria: criteria, tracks: spotify_tracks_matching(criteria) }
end

post '/track' do
  puts params[:id]
end