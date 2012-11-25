require 'sinatra'
require 'slim'
require 'sinatra/content_for'
require 'lastfm'
require 'spotify'
require 'track_queue'

include Lastfm
include Spotify
include TrackQueue

set :root, File.dirname(__FILE__)+'/..'

get '/lastfm/:user' do |user|
  slim :index, locals: {tracks: recent_lastfm_tracks_for(user) }
end

get '/queue' do
  slim :queue, locals: { queue: self }
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
  enqueue params[:track]
end