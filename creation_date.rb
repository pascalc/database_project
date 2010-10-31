#!/usr/bin/env ruby

require 'rubygems'
require 'sequel'
require 'util.rb'
require 'date'

DB = Sequel.mysql('dbproject',:host => "localhost", :user => "dbproject")

query = DB["SELECT creation_date FROM Users WHERE username = ?",ARGV[0]]
exit if query.empty?	

d = nil
query.each do |row|
	d = row[:creation_date]
end
puts "#{ARGV[0]} has been alive for #{((Time.now - d)/(60*60*24)).round} days"
