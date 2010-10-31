#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'
require 'sequel'
require 'util.rb'
require 'date'

enable :sessions

# Set up the database connection

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "dbproject")

# Global variables
$categories = DB["SELECT name FROM Categories"]

# Helper functions

# Check if the logged in user is allowed to alter this ad 
def check_allowed(id)
   if not session["username"]
	session["warning"] = "Please log in first."
	redirect '/'
   end
   DB["SELECT * FROM Ads WHERE id = ?",id].each do |ad|
	if not ad[:fk_username] == session["username"]
		session["error"] = "Don't be naughty now."
		redirect '/ads/list'
	end
   end
end

########### ROUTES ###############

# Index
get '/' do
  erb :index
end

############ ADS ###########

# List all ads
get '/ads/list' do
  ads = DB["SELECT * FROM Ads ORDER BY creation_date DESC"]
  erb(:ads, :layout => true, :locals => {:mode => :list, :ads => ads})
end

# Category listings
get '/tag/:cat' do |cat|
   ads = DB["SELECT * FROM Ads WHERE fk_category = ? ORDER BY creation_date DESC",cat]
   if ads.empty?
   	session["error"] = "We don't have a #{cat} category."
        redirect '/ads/list'
   end
   erb(:ads, :layout => true, :locals => {:mode => :category, :title => cat, :ads => ads})
end

# Search for an ad
get '/ads/search' do
   query = params['query']
   category = params['category']
   ads = DB["SELECT * FROM Ads WHERE fk_category = ? AND (title LIKE ? OR description LIKE ? OR fk_username LIKE ?)",category,"%#{query}%","%#{query}%","%#{query}%"]
   if ads.empty?
   	session["error"] = "We couldn't find anything matching '#{query}' under #{category}."
        redirect '/'
   end
   erb(:ads, :layout => true, :locals => {:mode => :search, :query => query, :ads => ads})
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
   	DB["INSERT INTO Ads (id, title, description, fk_category, creation_date, fk_username)
                VALUES (null, ?, ?, ?, null, ?)", title, description, category,session["username"]].insert
   	session["success"] = "Created a new ad!"
   	redirect "/ads/#{session["username"]}/list"
   rescue
	session["error"] = "Something went wrong..."
     	redirect '/ads/new'
   end	
end

# Show an ad
get '/ads/show/:id' do |id|
   ad = DB["SELECT * FROM Ads A, Users U WHERE A.id = ? AND U.username = A.fk_username",id]
   if ad.empty?
	session["error"] = "Couldn't find the ad you were looking for."
	redirect '/ads/list'
   end
   erb(:show_ad, :layout => true, :locals => {:ad => ad})
end

# Delete an ad
get '/ads/delete/:id' do |id|
   check_allowed(id) 
   DB["DELETE FROM Ads WHERE id = ?", id].delete
   session["success"] = "Deleted ad number #{id}"
   redirect "/ads/#{session["username"]}/list"
end

# Show the edit ad form
get '/ads/edit/:id' do |id|
   check_allowed(id) 
   ad = DB["SELECT * FROM Ads WHERE id = ?",id]
   if ad.empty?
	   session["error"] = "We don't have an ad with an id of #{id}"
	   redirect "/ads/#{session["username"]}/list"
   end
   erb(:edit_ad, :layout => true, :locals => {:ad => ad})
end

# Edit an ad
post '/edit_ad/:id' do |id|
   check_allowed(id)
   
   title = params['title']
   description = params['description']
   category = params['category']
   
   if title.length == 0 or description.length == 0 or category.length == 0
        session["error"] = "Please enter a title, description and category."
	redirect "/ads/edit/#{id}"
   end

   DB["UPDATE Ads SET title = ?, description = ?, fk_category = ? WHERE id = ?",title, description,category,id].update
   session["success"] = "Updated ad number #{id}!"
   redirect "/ads/#{session["username"]}/list"
end

################## USERS ##########################

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
   
   redirect '/users/dashboard'
end

# User's dashboard
get '/users/dashboard' do
   if not session["username"]
	   session["warning"] = "Please log in first."
	   redirect '/'
   end
   username = session["username"]
      
   num_ads_query = DB["SELECT COUNT(*) AS number FROM Ads WHERE fk_username = ?", username] 
   if num_ads_query.empty?
	   nr_ads = 0
   else
	   nr_ads = nil
   	   num_ads_query.each do |row|
		nr_ads = row[:number]
   	   end
   end

   creation_date = nil
   DB["SELECT creation_date from Users WHERE username = ?", username].each do |row|
	creation_date = row[:creation_date]
   end
   alive = ((Time.now - creation_date)/(60*60*24)).round   

   erb(:user_page, :layout => true, :locals => {:nr_ads => nr_ads, :alive => alive})
end

# Log out
get '/logout' do
   username = session["username"]
   session["username"] = nil
   session["info"] = "Goodbye #{username}!"
   redirect '/'
end

# List all users
get '/users/list' do
  if session["username"] == "pascal" or session["username"] == "joakim"
  	users = DB["SELECT * FROM Users ORDER BY creation_date DESC"]
  	erb(:users, :layout => true, :locals => {:users => users})
  else
	session["error"] = "HACKER FAIL :D"
	redirect '/'
  end
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
   redirect '/users/dashboard'
end

# List all ads belonging to a user
get '/ads/:username/list' do |username|
   ads = DB["SELECT * FROM Ads WHERE fk_username = ?",username]
   if ads.empty?
	   session["warning"] = "You don't have any ads yet."
	   redirect '/users/dashboard'
   end
   erb(:ads, :layout => true, :locals => {:mode => :user, :username => username, :ads => ads})
end
