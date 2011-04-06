require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__)+'/helper'
require File.dirname(__FILE__)+'/main'

set :environment, :development

set :port, 8087
set :server, 'webrick'

Sinatra::Application.run
