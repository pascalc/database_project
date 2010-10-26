#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'haml'
require 'erb'
require 'util.rb'

get '/weather' do
  @weather = "sunny"
  @temperature = 80
  haml :weather
end

get '/' do 
  @employees = (1..10).to_a.map { Util::random_string(4+rand(6)) } 
  erb :table
end
