#!/usr/bin/env ruby
# mike built this 2015-01-15

require 'rest_client'
require 'rexml/document'
require_relative 'config/ba_config'

def getBusInfo

apiToken = BaConfig.apiToken
puts apiToken
apiStopCode = '16104'
routeToShow = '43-Masonic'

api_call_url = "http://services.my511.org/Transit2.0/GetNextDeparturesByStopCode.aspx?token=#{apiToken}&stopCode=#{apiStopCode}"

puts "      API key: #{apiToken}"
puts "    Stop Code: #{apiStopCode}"
puts "          URL: #{api_call_url}"

begin
  xml_data = RestClient::Request.execute(:url => api_call_url, :ssl_version => 'TLSv1', :method => 'get')
rescue => e
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

# puts xml.elements.each("RTT/AgencyList/Agency/RouteList/Route/") { |element| puts element.attributes["name"] }

puts "    route: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']"].attributes["Name"]}"
puts "direction: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/"].attributes["Code"]}"
puts "     stop: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/StopList/Stop/"].attributes["name"]}"
puts " next bus: #{xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime"].get_text.value} minutes"
nextBusMinutes = xml.elements["RTT/AgencyList/Agency/RouteList/Route[@Name='#{routeToShow}']/RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList/DepartureTime"].get_text.value

# RouteDirectionList/RouteDirection/StopList/Stop/DepartureTimeList

end #GetBusInfo class
