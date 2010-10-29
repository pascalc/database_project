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
   
   if title.length == 0 or description.length == 0 or category.length == 0
        session["message"] = "Please enter a title, description and category."
	redirect '/ads/new'
   end

   begin 
   	DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, ?)", title, description, category,session["username"]].insert
   	session["message"] = "Created a new ad!"
   	redirect '/ads/list'
   rescue
	session["message"] = "Something went wrong..."
     	redirect '/ads/new'
   end	
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
   erb :new_user
end

# Create new user
post '/new_user' do
   username = params['username']
   password = params['password']
   email = params['email']

   if username.length == 0 or password.length == 0 or email.length == 0
        session["message"] = "Please enter a username, password and email."
	redirect '/users/new'
   end

   begin 
   	DB["INSERT INTO Users VALUES (?,?,?,null)",username,password,email].insert
   rescue
	session["message"] = "Sorry, we already have a user called #{username}."
	redirect '/users/new'
   end

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
