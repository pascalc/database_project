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

# Index
get '/' do
   redirect '/index.html'
end

# List all users
get '/users/list' do
  @users = DB["SELECT * FROM Users ORDER BY creation_date DESC"]
  erb :users
end

# List all ads
get '/ads/list' do
  @tag = nil	
  @ads = DB["SELECT * FROM Ads ORDER BY creation_date DESC"]
  erb :ads
end

# Show new ad form
get '/ads/new' do
   return "Please log in first" unless session["username"]
   erb :new_ad
end

# Create a new ad
post '/new_ad' do
   title = params['title']
   description = params['description']
   category = params['category']
   DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, ?)", title, description, category,session["username"]].insert
   redirect '/ads/list'
end

# Category listings
get '/tag/*' do
   @tag = params["splat"].first
   @ads = DB["SELECT * FROM Ads WHERE category = ? ORDER BY creation_date DESC",@tag]
   return "We don't have a #{@tag} category." if @ads.empty?
   erb :ads 
end

# Show new user form
get '/users/new' do
   redirect '/new_user.html'
end

# Create new user
post '/new_user' do
   username = params['username']
   password = params['password']
   email = params['email']
   DB["INSERT INTO Users VALUES (?,?,?,null)",username,password,email].insert

   session["username"] = username

   redirect '/users/list'
end

# Log in
post '/login' do
   username = params['username']
   password = params['password']
   
   result = DB["SELECT username,password FROM Users WHERE username = ? AND password = ?",username,password]
   return "Don't try and hack me, #{username} = bad boy!" if result.empty?

   session["username"] = username

   "Welcome back #{username}!"
end

# Log out
get '/logout' do
   username = session["username"]
   session["username"] = nil
   "Goodbye #{username}!"
end
