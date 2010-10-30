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
  categories = DB["SELECT DISTINCT category FROM Ads"]
  erb(:index, :layout => false, :locals => {:categories => categories})
end

# List all users
get '/users/list' do
  users = DB["SELECT * FROM Users ORDER BY creation_date DESC"]
  erb(:users, :layout => true, :locals => {:users => users})
end

# List all ads
get '/ads/list' do
  ads = DB["SELECT * FROM Ads ORDER BY creation_date DESC"]
  erb(:ads, :layout => true, :locals => {:tag => nil, :ads => ads})
end

# Show new ad form
get '/ads/new' do
   if not session["username"]
      session["warning"] = "Please log in first"
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
        session["error"] = "Please enter a title, description and category."
	redirect '/ads/new'
   end

   begin 
   	DB["INSERT INTO Ads (id, title, description, category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, ?)", title, description, category,session["username"]].insert
   	session["success"] = "Created a new ad!"
   	redirect '/ads/list'
   rescue
	session["error"] = "Something went wrong..."
     	redirect '/ads/new'
   end	
end

# Category listings
get '/tag/:cat' do |cat|
   ads = DB["SELECT * FROM Ads WHERE category = ? ORDER BY creation_date DESC",cat]
   if ads.empty?
   	session["error"] = "We don't have a #{tag} category."
        redirect '/ads/list'
   end
   erb(:ads, :layout => true, :locals => {:tag => cat, :ads => ads})
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
        session["error"] = "Please enter a username, password and email."
	redirect '/users/new'
   end

   begin 
   	DB["INSERT INTO Users VALUES (?,?,?,null)",username,password,email].insert
   rescue
	session["error"] = "Sorry, we already have a user called #{username}."
	redirect '/users/new'
   end

   session["username"] = username
   session["info"] = "Welcome, #{username}!"
   redirect '/users/list'
end

# Log in
post '/login' do
   username = params['username']
   password = params['password']
   
   result = DB["SELECT username,password FROM Users WHERE username = ? AND password = ?",username,password]
   if result.empty?
      session["error"] = "Log in failed, please try again."
      redirect '/'
   end

   session["username"] = username
   session["info"] = "Welcome back #{username}!"
   redirect '/ads/list'
end

# Log out
get '/logout' do
   username = session["username"]
   session["username"] = nil
   session["info"] = "Goodbye #{username}!"
   redirect '/'
end
