#!/usr/bin/env ruby
# mike built this 2015-01-15

require 'rest_client'
require 'rexml/document'
require_relative 'config/ba_config'

# This method fetches bus information using the 511.org API.
def getBusInfo
  # Retrieve the API token from the configuration module
  apiToken = BaConfig.apiToken
  
  # Hardcoded stop code and route to show
  apiStopCode = '16104'
  routeToShow = '43-Masonic'

  # Construct the API URL with the token and stop code
  api_call_url = "http://services.my511.org/Transit2.0/GetNextDeparturesByStopCode.aspx?token=#{apiToken}&stopCode=#{apiStopCode}"

  # Initialize retry count for API request
  tries ||= 3

  begin
    # Execute the HTTP GET request to the API
    xml_data = RestClient::Request.execute(:url => api_call_url, :ssl_version => 'TLSv1', :method => 'get')
  rescue => e
    # Print error message and retry up to 3 times if there's an issue with the request
    puts "something went wrong with RestClient request"
    puts "goodbye"
    retry unless (tries -= 1).zero?
  end

  # Parse the XML response from the API
  xml = REXML::Document.new(xml_data)

  # Extract and print route, direction code, and stop name from the XML
  puts "    route: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']"].attributes["Name"]}" \
    ", #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/"].attributes["Code"]}" \
    " @ #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/StopList/Stop/"].attributes["name"]}"

  # Extract the next bus departure time
  nextBusMinutes = xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime"].get_text.value
end

# This method is only for testing purposes and is not called in production
# getBusInfo