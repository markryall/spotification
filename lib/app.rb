require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/json'
require 'slim'
require 'spotify'
require 'spotify_remote'
require 'track_queue'
require 'json'

include Spotify
include TrackQueue
include SpotifyRemote

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

def change_volume inc
  self.volume = self.volume + inc
  json percentage: self.volume
end

post('/volume/up') { change_volume 5 }
post('/volume/down') { change_volume -5 }

post('/player/rewind') { rewind }
post('/player/playpause') { playpause }
post('/player/fastforward') { fastforward }

post('/track') { enqueue params[:track] }

post '/album' do
  album = spotify_album params[:id]
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