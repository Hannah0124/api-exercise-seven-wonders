require 'httparty'
require 'dotenv'
require 'ap'

# Tell dotenv to look for the .env file !!!
Dotenv.load


# How to call ENV  
unless ENV["LOCATION_IQ_KEY"]
  puts "Could not load locaiton IQ key. Add `LOCATION_IQ_KEY` in the environment variable"
  exit 
end 


BASE_URL = "https://us1.locationiq.com/v1/search.php"


def get_location(search_term)

  # Solution 1
  # BASE_URL = "https://us1.locationiq.com/v1/search.php?key=#{LOCATION_IQ_KEY}&q=#{search_term}&format=json"

  response = HTTParty.get(BASE_URL, query: {
    key: ENV["LOCATION_IQ_KEY"],
    q: search_term,
    format: JSON
  })

  # p response.class # => HTTParty::Response

  response_data = JSON.parse(response.body)
  # p response_data.class # => Array
  
  
  return {
    search_term => {
      lat: response_data[0]["lat"], 
      lon: response_data[0]["lon"], 
    }
  }
end


def find_seven_wonders

  seven_wonders = ["Great Pyramid of Giza", "Gardens of Babylon", "Colossus of Rhodes", "Pharos of Alexandria", "Statue of Zeus at Olympia", "Temple of Artemis", "Mausoleum at Halicarnassus"]

  seven_wonders_locations = []

  seven_wonders.each do |wonder|
    sleep(0.5)
    seven_wonders_locations << get_location(wonder)
  end

  return seven_wonders_locations
end


ap "********"
ap "find seven wonders"
puts "#{find_seven_wonders}"

# Expecting something like:
# [{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]




# Optional Enhancement
# For an optional enhancement try to:

# 1.Make a request for driving directions from Cairo Egypt to the Great Pyramid of Giza.

# Reference: https://locationiq.com/
# Query on Berlin with three coordinates:
# curl 'https://us1.locationiq.com/v1/directions/driving/13.388860,52.517037;13.397634,52.529407;13.428555,52.523219?key=<YOUR_ACCESS_TOKEN>&overview=false'

puts "\n\n"
ap "********"
ap "Driving Directions from Cairo Egypt to the Great Pyramid of Giza"


def driving_directions
  
  cairo = {
    lon: 31.243666,
    lat: 30.048819
  }
  
  pyramid = {
    lon: 31.1342383751015,
    lat: 29.9791264 
  }
  
  url = "https://us1.locationiq.com/v1/directions/driving/#{cairo[:lon]},#{cairo[:lat]};#{pyramid[:lon]},#{pyramid[:lat]}?key=#{ENV["LOCATION_IQ_KEY"]}"
  
  response = HTTParty.get(url)
  response_data = JSON.parse(response.body)
  
  
  if response_data["code"] == "Ok"
    return "Driving directions: #{response_data}"
  end 
end 


p driving_directions


# 2. Turn these locations into the names of places: 

puts "\n\n"
ap "****************"
ap "Reverse look up locations"

# GET https://us1.locationiq.com/v1/reverse.php?key=YOUR_PRIVATE_TOKEN&lat=LATITUDE&lon=LONGITUDE&format=json


REVERSE_URL = "https://us1.locationiq.com/v1/reverse.php"


def look_up_locations

  locations = [{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]

  locations.each_with_index do |location, i|
    response = HTTParty.get(REVERSE_URL, query: {
      key: ENV["LOCATION_IQ_KEY"],
      lat: location[:lat],
      lon: location[:lon],
      format: JSON
    })

    response_data = JSON.parse(response.body)

    # ap response_data
    puts "##{i+1}: #{response_data["display_name"] }"
    
    sleep(1)
  end 
end 

ap look_up_locations