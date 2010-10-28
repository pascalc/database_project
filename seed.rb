#!/usr/bin/env ruby

# Script to populate our database with dummy data

require 'rubygems'
require 'sequel'
require 'util.rb'

NUM_USERS = 100
NUM_ADS = 500

# Connect to the database

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "pascal", :password => "dbproject")

# Clear existing data

DB["DELETE FROM Users"].delete
DB["DELETE FROM Ads"].delete

# Populate Users

users = DB[:Users]
NUM_USERS.times do 
	users.insert(:username => Util::random_string(4+rand(6)),
		     :password => Util::random_string(6+rand(4)),
		     :email => Util::random_string(1+rand(4)) + "@" + Util::random_string(1+rand(4)) + ".com",
		     :creation_date => nil)
end

# Populate Ads

CATEGORIES = ["books", "electronics", "appliances", "personal", "jobs"]

ads = DB[:Ads]
NUM_ADS.times do
	owner = nil
        DB["SELECT username FROM Users ORDER BY RAND() LIMIT 1"].each do |r|
		owner = r[:username]
	end	
	ads.insert(:id => nil,
		   :title => Util::random_string(4+rand(6)),
       		   :description => Util::random_string(50+rand(100)),
	   	   :category => CATEGORIES[rand(CATEGORIES.size)],
		   :creation_date => nil,
		   :fk_username => owner)
end	
