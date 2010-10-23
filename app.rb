#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'haml'
require 'erb'

get '/weather' do
  @weather = "sunny"
  @temperature = 80
  haml :weather
end

get '/' do 
  @employees = ["Chris", "Adam", "John", "Gandalf", "Balrog"]
  erb :table
end
