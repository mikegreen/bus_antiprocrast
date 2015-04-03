#!/usr/bin/env ruby
# mike built this 2015-03-28

require 'pi_piper'
require './bus_light_api.rb'
require 'date'

puts "setup pins for pipiper"
test_led_pin = 4
@mr_pin = PiPiper::Pin.new(pin: 18, direction: :out)
test_led = PiPiper::Pin.new(pin: test_led_pin, direction: :out)
@clock = PiPiper::Pin.new(pin: 23, direction: :out)
@latch = PiPiper::Pin.new(pin: 24, direction: :out)
@data = PiPiper::Pin.new(pin: 25, direction: :out)

def clear_register
	puts "master reset to start shift register over"
	@mr_pin.off
	@mr_pin.on
	latch_go
end

def latch_go
	@latch.on
	@latch.off
end

clear_register

@nextBusMinutes = getBusInfo
puts "next bus minutes: #{@nextBusMinutes}"

sleep_time = 1.0/5.0

puts "flash to say I'm alive"
4.times do
#	puts "turn on LED"
	test_led.on
	sleep(sleep_time)
	test_led.off
	sleep(sleep_time)
end

def shift_bit
	@data.on
	@clock.on
	@data.off
	@clock.off
end

def updateLights(minutes,lightDelay)
	clear_register
	minutes.to_i.times do
		shift_bit
		latch_go
		if lightDelay != 0 
			sleep(1.0/lightDelay)
		else
		end
	end
end

updateLights(@nextBusMinutes,4.0)

def checkForNew
	@nextBusMinutesOld = @nextBusMinutes 
	while 1 == 1  do
		if @nextBusMinutesOld.to_i > 10
			sleep(1)
		elsif @nextBusMinutesOld.to_i > 7
			sleep(1)
		elsif @nextBusMinutesOld.to_i > 5
			sleep(1)
		elsif @nextBusMinutesOld.to_i > 3
			sleep(1)
		else
			sleep(1)
		end
		@nextBusMinutesNew = getBusInfo
		if @nextBusMinutesNew != @nextBusMinutesOld
			puts "update lights with delay..."
			updateLights(@nextBusMinutesNew,2.0)
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

#updateLights(@nextBusMinutes,4.0)
#nextBusMinutes = getBusInfo
#puts "next bus minutes: #{@nextBusMinutes}"
#updateLights(@nextBusMinutes,0)
#@nextBusMinutesNew = getBusInfo

puts "done test"

#puts "clock_pin: #{io.read(clock_pin)}"
#puts "latch_pin: #{io.read(latch_pin)}"
#puts "data_pin: #{io.read(data_pin)}"
