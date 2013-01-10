require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/json'
require 'sinatra/partial'
require 'slim'
require 'track_queue'
require 'json'
require 'volume'

include TrackQueue
include Volume

if ENV['SPOTIFICATION_MODE'] == 'rdio'
  require 'rdio_controller'
  require 'rdio_search'
  include RdioController
  include RdioSearch
else
  require 'spotify_search'
  require 'spotify_controller'
  include SpotifyController
  include SpotifySearch
end

set :root, File.dirname(__FILE__)+'/..'
set :partial_template_engine, :slim

get '/' do
  slim :queue, locals: { queue: self }
end

get '/api/queue' do
  tracks = []
  each_track { |track| tracks << track }
  json tracks: tracks
end

get '/mobile' do
  slim :mobile, layout: false
end

post '/api/dequeue' do
  destroy params[:id]
end

get '/tracks' do
  slim :tracks, locals: {criteria: '', tracks: [], info: nil}
end

post '/tracks' do
  criteria = params[:criteria]
  tracks, info = tracks_matching criteria
  slim :tracks, locals: {criteria: criteria, tracks: tracks, info: info }
end

get '/api/search/tracks' do
  criteria = params[:criteria]
  tracks, info = tracks_matching criteria
  json tracks: tracks, info: info
end

get '/albums' do
  slim :albums, locals: {criteria: '', albums: [], info: nil}
end

post '/albums' do
  criteria = params[:criteria]
  albums, info = albums_matching criteria
  slim :albums, locals: {criteria: criteria, albums: albums, info: info }
end

get '/api/search/albums' do
  criteria = params[:criteria]
  albums, info = albums_matching criteria
  json albums: albums, info: info
end

get '/artists' do
  slim :artists, locals: {criteria: '', artists: [], info: nil}
end

post '/artists' do
  criteria = params[:criteria]
  artists, info = artists_matching criteria
  slim :artists, locals: {criteria: criteria, artists: artists, info: info }
end

get '/api/search/artists' do
  criteria = params[:criteria]
  artists, info = artists_matching criteria
  json artists: artists, info: info
end

def change_volume inc
  self.volume = self.volume + inc
  json percentage: self.volume
end

post('/volume') do
  self.volume = params[:percentage].to_i
  json percentage: self.volume
end

post('/volume/up') { change_volume 5 }
post('/volume/down') { change_volume -5 }

post('/player/rewind') { rewind }
post('/player/fastforward') { fastforward }

post '/player/playpause' do
  playpause
  json state: player_state
end

post '/api/enqueue/track' do
  track = track_info params[:id]
  enqueue track
  json track
end

post '/api/enqueue/album' do
  album = album_info params[:id]
  tracks = 0
  if album
    album['tracks'].each do |track|
      tracks += 1
      enqueue track
    end
  end
  json tracks: tracks
end

get '/tracks/:id' do |id|
  json album_info id
end

get '/artist/:id' do |id|
  artist = artist_info id
  slim :artist, locals: {artist: artist}
end

if ENV['LASTFM_API_KEY'] and ENV['LAST_FM_USER']
  require 'lastfm'

  include Lastfm

  get '/lastfm' do
    slim :lastfm, locals: {tracks: recent_lastfm_tracks_for(ENV['LAST_FM_USER']) }
  end
end