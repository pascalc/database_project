require 'sinatra'
require 'haml'

get '/weather' do
  @weather = "sunny"
  @temperature = 80
  haml :weather
end
