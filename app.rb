# encoding: utf-8

class App < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/support' do
    erb :support
  end
end