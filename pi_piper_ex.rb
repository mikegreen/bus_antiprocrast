#!/usr/bin/env ruby
# mike built this 2015-03-28

require 'pi_piper'
require './bus_light_api.rb'

nextBusMinutes = getBusInfo
puts "next bus minutes: #{nextBusMinutes}"

test_led_pin = 4

sleep_time = 1.0/5.0

puts "setup pins for pipiper"
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

nextBusMinutes.to_i.times do
	shift_bit
	latch_go
end

sleep(1)

clear_register

puts "done test"

#puts "clock_pin: #{io.read(clock_pin)}"
#puts "latch_pin: #{io.read(latch_pin)}"
#puts "data_pin: #{io.read(data_pin)}"
