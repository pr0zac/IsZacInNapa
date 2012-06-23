require 'rubygems'
require 'sinatra'
require './rosumi.rb'

get '/' do
  begin
    rosumi = Rosumi.new(ENV['ROSUMI_UNAME'], ENV['ROSUMI_PWD'])
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
      '<html><center><h1>Yes</h1></center></html>'
    else
      '<html><center><h1>No</h1></center></html>'
    end
  rescue
    '<html><center><h1>No clue</h1></center></html>'
  end
end
