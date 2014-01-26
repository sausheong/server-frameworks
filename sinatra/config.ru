require 'rubygems'
require 'bundler'
Bundler.require
require 'active_support/inflections'

require './server'
run Sinatra::Application