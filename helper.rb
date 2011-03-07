require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader'
require 'bson'
require 'mongoid'
gem 'mongoid','>=2.0.0.rc.7'
require 'yaml'
require 'json'
require File.dirname(__FILE__)+'/models/page'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
end

Mongoid.configure{|conf|
  conf.master = Mongo::Connection.new(@@conf['mongo_server'], @@conf['mongo_port']).db(@@conf['mongo_dbname'])
}

def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

def routed?(path)
  Sinatra::Application.routes['GET'].map{|i|i.first}.each{|i|
    next if i.to_s == /^\/(.*?)$/.to_s
    return true if path =~ i
  }
  return false
end

class Err < StandardError
end
