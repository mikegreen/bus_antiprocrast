#!/usr/bin/env ruby

# mike built this 2015-01-15

require 'rest_client'
require 'rexml/document'
require 'require_all'
require 'net/http'
require_relative 'config/ba_config'
require 'rpi_gpio'

# Retrieve the API token from the configuration file
apiToken = BaConfig.apiToken
puts apiToken

# Define the stop code and route to be queried
apiStopCode = '16104'
routeToShow = '43-Masonic'

# Simple method to test basic functionality
def testmethod
  puts "foo"
end

testmethod

# Construct the API call URL using the token and stop code
api_call_url = "http://services.my511.org/Transit2.0/GetNextDeparturesByStopCode.aspx?token=#{apiToken}&stopCode=#{apiStopCode}"

puts "      API key: #{apiToken}"
puts "    Stop Code: #{apiStopCode}"
puts "          URL: #{api_call_url}"

# Execute the API call and handle exceptions
begin
  xml_data = RestClient::Request.execute(:url => api_call_url, :ssl_version => 'TLSv1', :method => 'get')
rescue => e
  puts "Something went wrong, return: #{e.response}"
  puts "goodbye"
  exit
else
  puts "API call successful, returned code: #{xml_data.code}"
end

# Parse the XML data returned from the API
xml = REXML::Document.new(xml_data)

# Get the size of the result to check how many elements are returned
result_size = xml.root.elements.size
puts "                     Rows returned: #{result_size}"

# Placeholder for CSV header (not used in current script)
csv_header = "nothing here yet"

# Helper function to check if an XML element is empty and return a blank string if true
def check_empty_element(p, name)
  p.elements[name].text || ""
end

# Output route, direction, stop, and next bus information from the XML
puts "    route: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']"].attributes["Name"]}"
puts "direction: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/"].attributes["Code"]}"
puts "     stop: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/"].attributes["name"]}"
puts " next bus: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime"].get_text.value} minutes"

# Initialize an array to store all coming bus times
ary = Array.new

# Iterate through each departure time and push to the array
puts 'interate thru all coming buses and push to array'
xml.elements.each("RTT/AgencyList/Agency/RouteList/Route[@Name='43-Masonic']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime") do |element| 
  ary.push(element.get_text.value.to_s)
end

# Output the contents of the array containing bus times
puts "array contents: #{ary}"

# Additional XML parsing logic (not utilized in current script)
xml.elements.each('RTT/AgencyList/Agency') do |e|
  e.elements.each('*/*/Agency/*') do |p|
    # Additional parsing could be implemented here
  end
end