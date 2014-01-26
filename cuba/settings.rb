require 'bundler'
Bundler.require
require 'rack/static'

Dir.new("#{File.dirname(__FILE__)}/views").each { |view| require "./views/#{view}" if File.extname(view) == '.rb' }

Cuba.use Rack::Session::Cookie, :secret => '__blogs__'
Cuba.use Rack::Protection
Cuba.use Rack::Static,
  urls: %w[/js /css /images /fonts],
  root: "./public"
