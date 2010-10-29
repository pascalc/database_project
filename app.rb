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
   if not session["username"]
      session["message"] = "Please log in first"
      redirect '/'
   end
   erb :new_ad
end

# Create a new ad
post '/new_ad' do
   title = params['title']
   description = params['description']
   category = params['category']
   DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, ?)", title, description, category,session["username"]].insert
   session["message"] = "Created a new ad!"
   redirect '/ads/list'
end

# Category listings
get '/tag/*' do
   @tag = params["splat"].first
   @ads = DB["SELECT * FROM Ads WHERE category = ? ORDER BY creation_date DESC",@tag]
   if @ads.empty?
   	session["message"] = "We don't have a #{@tag} category."
        redirect '/ads/list'
   end	
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
   session["message"] = "Welcome, #{username}!"
   redirect '/users/list'
end

# Log in
post '/login' do
   username = params['username']
   password = params['password']
   
   result = DB["SELECT username,password FROM Users WHERE username = ? AND password = ?",username,password]
   if result.empty?
      session["message"] = "Log in failed, please try again."
      redirect '/'
   end

   session["username"] = username
   session["message"] = "Welcome back #{username}!"
   redirect '/ads/list'
end

# Log out
get '/logout' do
   username = session["username"]
   session["username"] = nil
   session["message"] = "Goodbye #{username}!"
   redirect '/'
end
