#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'erb'
require 'util.rb'

SIZE = 10

get '/users/list' do 
  @usernames = (1..SIZE).to_a.map { Util::random_string(4+rand(6)) }
  @passwords = (1..SIZE).to_a.map { Util::random_string(6+rand(4)) }
  @emails = (1..SIZE).to_a.map do 
	  Util::random_string(1+rand(4)) + "@" + Util::random_string(1+rand(4)) + ".com"
  end
  @dates = (1..SIZE).to_a.map { Util::random_number(6+rand(4)) }
  erb :users
end
