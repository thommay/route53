#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack/flash'
require 'fog'
require 'haml'
require 'json'

set :sessions, true
set :haml, {:format => :html5, :escape_html => true}
use Rack::Flash

configure :production do
  set :haml, {:ugly => true}
end

before do
  Fog.credentials
  @fog = Fog::DNS.new(:provider=>'AWS')
end

get '/zones/:id' do
  zone = @fog.zones.get params[:id]
  zone.records.all.to_json
end

get '/zones' do
  @fog.zones.all.to_json
end

get '/' do
  haml :index
end

