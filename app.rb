#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'
require 'util.rb'

# Set up the database connection

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "pascal", :password => "dbproject")

# Routes

# List all users
get '/users/list' do
  @users = DB["SELECT * FROM Users"]
  erb :users
end

# List all ads
get '/ads/list' do 
  @ads = DB["SELECT * FROM Ads"]
  erb :ads
end

# Create a new ad
post '/new_ad' do
   title = params['title']
   description = params['description']
   category = params['category']
   DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, '1Yea')", title, description, category].insert
   "Created a new ad!"
end
