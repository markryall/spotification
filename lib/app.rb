require 'sinatra'
require 'sinatra/content_for'
require 'slim'
require 'spotify'
require 'track_queue'

include Spotify
include TrackQueue

set :root, File.dirname(__FILE__)+'/..'

get '/' do
  slim :queue, locals: { queue: self }
end

post '/dequeue' do
  destroy params[:id]
end

get '/tracks' do
  slim :tracks, locals: {criteria: '', tracks: []}
end

post '/tracks' do
  criteria = params[:criteria]
  results =  criteria
  slim :tracks, locals: {criteria: criteria, tracks: spotify_tracks_matching(criteria) }
end

get '/albums' do
  slim :albums, locals: {criteria: '', albums: []}
end

post '/albums' do
  criteria = params[:criteria]
  results =  criteria
  slim :albums, locals: {criteria: criteria, albums: spotify_albums_matching(criteria) }
end

post '/track' do
  enqueue params[:track]
end

post '/album' do
  album = spotify_lookup(params[:id], 'track')['album']
  album['tracks'].each do |track|
    enqueue 'id' => track['href'],
      'name' => track['name'],
      'album' => album['name'],
      'artists' => track['artists'].map{|a| a['name']}.join(',')
  end
end

if ENV['LASTFM_API_KEY'] and ENV['LAST_FM_USER']
  require 'lastfm'

  include Lastfm

  get '/lastfm' do
    slim :lastfm, locals: {tracks: recent_lastfm_tracks_for(ENV['LAST_FM_USER']) }
  end
end