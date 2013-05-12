require 'rubygems'
require 'bundler'

Bundler.require

require './app'
set :port, 3001
run Sinatra::Application
