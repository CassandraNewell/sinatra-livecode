require 'sinatra'
require 'pry'
require 'csv'
require_relative 'app/restaurant.rb'

set :bind,'0.0.0.0'  # bind to all interfaces, http://www.sinatrarb.com/configuration.html

def make_restaurants_array
  @restaurants = []
  CSV.foreach('restaurants.csv', headers: true) do |row|
    @restaurants << Restaurant.new(row["id"], row["name"], row["address"], row["description"], row["url"], row["image"])
  end
  @restaurants
end

get '/restaurants' do
  @restaurants = make_restaurants_array

  erb :index
end

get '/restaurant/:id' do
  restaurants = make_restaurants_array

  restaurants.each do |restaurant|
    if restaurant.id == params["id"]
      @restaurant = restaurant
    end
  end

  erb :show
end

get '/restaurants/new' do
  erb :new
end

post '/restaurants' do
  new_id = make_restaurants_array.length + 1
  CSV.open("restaurants.csv", "a") do |csv|
    csv << [new_id, params[:name], params[:address], params[:description], params[:url], params[:image]]
  end

  redirect to '/restaurants'
end
