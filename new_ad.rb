#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'

enable :sessions

# Fetch the data inserted and take the users credentials and insert it into the ads table
post '/new_ad' do
	# Establish a connection to the database
	DB = Sequel.mysql('dbproject',:host => "localhost", :user => "pascal", :password => "dbproject")
	
	title = params['title']
	description = params['description']
	content = params['content']
	dbh.query("INSERT INTO username (id, title, description, category, creation_date, fk_username)
                VALUES ('null', #{title}, #{content}, #{description}, null, session[#{username}])")
end



  
