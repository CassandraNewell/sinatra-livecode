require 'sinatra'
require 'sinatra/reloader'

require 'pry'
require 'csv'
require_relative 'app/restaurant.rb'

set :bind,'0.0.0.0'  # bind to all interfaces, http://www.sinatrarb.com/configuration.html

def make_restaurant_array
  restaurants = []
  CSV.foreach('restaurants.csv', headers: true) do |row|
    restaurants << Restaurant.new(
      row["id"],
      row["name"],
      row["address"],
      row["description"],
      row["url"],
      row["image"]
    )
  end
  restaurants
end

get '/' do
  redirect to '/restaurants'
end

get '/restaurants' do
  @restaurants = make_restaurant_array
  erb :index
end

get '/restaurants/new' do

  erb :new
end

get '/restaurants/:id' do
  restaurants = make_restaurant_array

  restaurants.each do |restaurant|
    if restaurant.id == params["id"]
      @restaurant = restaurant
    end
  end

  erb :show
end
