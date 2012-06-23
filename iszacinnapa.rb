require 'rubygems'
require 'sinatra'
require './rosumi.rb'

get '/' do
  begin
    rosumi = Rosumi.new('zacmorris@gmail.com', 'sh3llc0de')
    locate_info = rosumi.locate(1)

    lat = locate_info[:latitude]
    long = locate_info[:longitude]

    res = Net::HTTP.start('api.geonames.org') do |http|
      http.get("/findNearbyPostalCodesJSON?lat=#{lat}&lng=#{long}&username=pr0zac")
    end

    rev_geocode_info = JSON(res.body)

    in_napa = false
    rev_geocode_info['postalCodes'].each do |code_info|
      if code_info['placeName'] == 'Napa'
        in_napa = true
      end
    end

    if in_napa
      'Yes'
    else
      'No'
    end
  rescue
    'Not sure'
  end
end
