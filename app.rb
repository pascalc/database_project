#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'
require 'util.rb'

enable :sessions

# Set up the database connection

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "pascal", :password => "dbproject")

########### ROUTES ###############

# List all users
get '/users/list' do
  @users = DB["SELECT * FROM Users ORDER BY creation_date DESC"]
  erb :users
end

# List all ads
get '/ads/list' do 
  @ads = DB["SELECT * FROM Ads ORDER BY creation_date DESC"]
  erb :ads
end

# Create a new ad
post '/new_ad' do
   title = params['title']
   description = params['description']
   category = params['category']
   DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, '1Yea')", title, description, category].insert
   redirect '/ads/list'
end

# Create new user
post '/new_user' do
   username = params['username']
   password = params['password']
   email = params['email']
   DB["INSERT INTO Users VALUES (?,?,?,null)",username,password,email].insert
   redirect '/users/list'
end

# Log in
post '/login' do
   username = params['username']
   password = params['password']
   
   result = DB["SELECT username,password FROM Users WHERE username = ? AND password = ?",username,password]
   return "Don't try and hack me, #{username} = bad boy!" if result.empty?

   "Welcome back #{username}!"
end
