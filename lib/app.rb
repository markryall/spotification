require 'sinatra'
require 'sinatra/content_for'
require 'slim'
require 'spotify'
require 'track_queue'

include Spotify
include TrackQueue

set :root, File.dirname(__FILE__)+'/..'

get '/' do
  slim :index
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

if ENV['LASTFM_API_KEY'] and ENV['LAST_FM_USER']
  require 'lastfm'

  include Lastfm

  get '/lastfm' do
    slim :lastfm, locals: {tracks: recent_lastfm_tracks_for(ENV['LAST_FM_USER']) }
  end
end