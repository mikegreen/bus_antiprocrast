#!/usr/bin/env ruby

# mike built this 2015-03-14

require 'wiringpi'

clock_pin = 4
latch_pin = 5
data_pin = 6

io = WiringPi::GPIO.new 

#io.mode(clock_pin, OUTPUT)
#io.mode(latch_pin, OUTPUT)
#io.mode(data_pin, OUTPUT)

sleep_time = 1.0/4.0
puts "starting"
io.shiftOutArray(data_pin, clock_pin, latch_pin, [0,0,0,0,0,0,0,0])
sleep(1)
io.shiftOutArray(data_pin, clock_pin, latch_pin, [1,1,1,1,1,1,1,1])
sleep(1)
io.shiftOutArray(data_pin, clock_pin, latch_pin, [0,0,0,0,0,0,1,1])
#io.shiftOutArray(data_pin, clock_pin, latch_pin, [1,1,1,1,1,1,1,1])
sleep(1)
#io.write(clock_pin,0)
#sleep(sleep_time)

puts "clock_pin: #{io.read(clock_pin)}"
puts "latch_pin: #{io.read(latch_pin)}"
puts "data_pin: #{io.read(data_pin)}"
