#!/usr/bin/env ruby
# mike built this 2015-03-28

require 'pi_piper'
require './bus_light_api.rb'
require 'date'

# Setup PiPiper pins for controlling the hardware
puts "setup pins for pipiper"
test_led_pin = 4
@mr_pin = PiPiper::Pin.new(pin: 18, direction: :out)  # Master reset pin
test_led = PiPiper::Pin.new(pin: test_led_pin, direction: :out)  # Test LED pin
@clock = PiPiper::Pin.new(pin: 23, direction: :out)  # Clock pin for shift register
@latch = PiPiper::Pin.new(pin: 24, direction: :out)  # Latch pin for shift register
@data = PiPiper::Pin.new(pin: 25, direction: :out)  # Data pin for shift register

# Function to clear the shift register
def clear_register
	puts "master reset to start shift register over"
	@mr_pin.off
	@mr_pin.on
	latch_go
end

# Function to trigger the latch pin
def latch_go
	@latch.on
	@latch.off
end

clear_register

# Fetch the next bus arrival time in minutes
@nextBusMinutes = getBusInfo
puts "next bus minutes: #{@nextBusMinutes}"

sleep_time = 1.0/5.0

# Flash the test LED to indicate the script is running
puts "flash to say I'm alive"
4.times do
	test_led.on
	sleep(sleep_time)
	test_led.off
	sleep(sleep_time)
end

# Function to shift a bit in the shift register
def shift_bit
	@data.on
	@clock.on
	@data.off
	@clock.off
end

# Function to update the lights based on the bus arrival time
def updateLights(minutes, lightDelay)
	clear_register
	minutes.to_i.times do
		shift_bit
		latch_go
		sleep(1.0/lightDelay) if lightDelay != 0
	end
end

updateLights(@nextBusMinutes, 4.0)

# Function to continuously check for new bus times and update lights accordingly
def checkForNew
	@nextBusMinutesOld = @nextBusMinutes 
	while true
		sleep(1)  # Sleep to reduce the frequency of API calls

		@nextBusMinutesNew = getBusInfo
		if @nextBusMinutesNew != @nextBusMinutesOld
			puts "update lights with delay..."
			updateLights(@nextBusMinutesNew, 2.0)
			@nextBusMinutesOld = @nextBusMinutesNew
			puts "old #{@nextBusMinutesOld} new #{@nextBusMinutesNew}"
		else
			puts "old = new"
		end
		time = Time.now.to_s
		time = DateTime.parse(time).strftime("%d/%m/%Y %H:%M") 
		puts "new: #{@nextBusMinutesNew} time: #{time}"		
	end 
end

checkForNew

puts "done test"