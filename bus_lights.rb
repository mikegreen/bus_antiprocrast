#!/usr/bin/env ruby

# mike built this 2015-01-15

require 'rest_client'
require 'rexml/document'
# require 'stathat'
require 'require_all'
# require 'net/ftp'
# require 'date'
require 'net/http'
require_relative 'config/ba_config'

# t = DateTime.now

apiToken = BaConfig.apiToken
puts apiToken
apiStopCode = '16104'
routeToShow = '43-Masonic'

# def log_stathat(stathat_path)
#  StatHat::API.ez_post_count("#{RoomkeyConfig.stathat_prefix}.#{stathat_path}", RoomkeyConfig.stathat_key, 1)
# end

# log_stathat('startup')

api_call_url = "http://services.my511.org/Transit2.0/GetNextDeparturesByStopCode.aspx?token=#{apiToken}&stopCode=#{apiStopCode}"

puts "      API key: #{apiToken}"
puts "    Stop Code: #{apiStopCode}"
puts "          URL: #{api_call_url}"

begin
  xml_data = RestClient::Request.execute(:url => api_call_url, :ssl_version => 'TLSv1', :method => 'get')
rescue => e
  # this doesnt work for some reason - returns blank, test with a date range of 10 days or so, which seems to timeout the RK api (bad)
  puts xml_data.code
  puts "Somethign went wrong, return: #{e.response}"
  puts "goodbye"
  exit
else
  puts "API call successful, returned code: #{xml_data.code}"
end

xml = REXML::Document.new(xml_data)

result_size = xml.root.elements.size
puts "                     Rows returned: #{result_size}"

delimiter = "|"

csv_header = "nothing here yet"


# check if XML value is empty (often some are) and set to blank if so so we don't fail when building the csv
def check_empty_element(p, name)
  p.elements[name].text || ""
end # def check_empty_element 

# puts xml.elements.each("RTT/AgencyList/Agency/RouteList/Route/") { |element| puts element.attributes["name"] }

puts "    route: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']"].attributes["Name"]}"
puts "direction: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/"].attributes["Code"]}"
puts "     stop: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/"].attributes["name"]}"
puts " next bus: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime"].get_text.value} minutes"

# RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList

ary = Array.new    #=> []

puts 'interate thru all coming buses and push to array'
xml.elements.each("RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime") do |element| 
  # puts element.get_text.value.to_s
  ary.push (element.get_text.value.to_s)
end

puts "array contents: #{ary}"

xml.elements.each('RTT/AgencyList/Agency') do |e|

    e.elements.each('*/*/Agency/*') do |p|
    # csv_file.puts output + [e.attributes['id'], e.textof("foo"), p.attributes['']].flatten.join("|") + "\n"
    
    # check if xml element is populated and put to variable if it is 
    # todo: (probably a better way to do this)

    reservation = []
    reservation << check_empty_element(p, 'PropertyCode' )
    reservation << check_empty_element(p, 'Title')
    reservation << check_empty_element(p, 'FirstName')
    reservation << check_empty_element(p, 'LastName')
    reservation << check_empty_element(p, 'EmailAddress' )
    reservation << check_empty_element(p, 'TelephoneNumber')
    reservation << check_empty_element(p, 'City' )
    reservation << check_empty_element(p, 'StateCode' )
    reservation << check_empty_element(p, 'CountryCode' )
    reservation << check_empty_element(p, 'ArrivalDate' )
    reservation << check_empty_element(p, 'DepartureDate' )
    reservation << check_empty_element(p, 'RoomNumber' )

    # build a row of the csv
    reservation_row = reservation.join(delimiter) + "\n"
    # puts to screen for debug
    puts reservation_row


    # this shouldn't be necessary
    #reservation_row = ""
  end # ReservationGuestProfile do
end # ArrayOfReservationGuestProfile do


