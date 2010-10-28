#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'
require 'util.rb'

# Set up the database connection

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "pascal", :password => "dbproject")

# Routes

get '/users/list' do
  @users = DB["SELECT * FROM Users"]
  erb :users
end

get '/ads/list' do 
  @ads = DB["SELECT * FROM Ads"]
  erb :ads
end

post '/new_ad' do
	"Created a new ad"
	puts "Number of rows returned: #{res.num_rows}"
end
