#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader' if development?
require 'rack/flash'
require 'fog'
require 'haml'

set :sessions, true
set :haml, {:format => :html5, :escape_html => true}
use Rack::Flash

configure :production do
  set :haml, {:ugly => true}
end

helpers do
  def partial(name, opts={})
    haml name, opts.merge!(:layout=>false)
  end
end

before do
  Fog.credentials
  @fog = Fog::DNS.new(:provider=>'AWS')
end


get '/:name' do
  name = params[:name].end_with?(".") ? params[:name] : params[:name] + "."
  @zone = @fog.zones.all.select { |d| d.domain == name }.first
  @records = @zone.records.all
  haml :zone
end

get '/' do
  @zones = @fog.zones.all
  haml :index
end

