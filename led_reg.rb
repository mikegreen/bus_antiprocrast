#!/usr/bin/env ruby

# mike built this 2015-03-14

require 'wiringpi'

CLOCK_PIN = 4
LATCH_PIN = 5
DATA_PIN = 6 
MR_PIN = 7

io = WiringPi::GPIO.new 
# io.write(LATCH_PIN, LOW)
# io.shiftOut(DATA_PIN, CLOCK_PIN,MSBFIRST,0)
# io.write(LATCH_PIN, HIGH)

io.mode(MR_PIN, OUTPUT)
io.write(MR_PIN, LOW) # master reclear
io.write(MR_PIN, HIGH) # enable again

#io.mode(CLOCK_PIN, OUTPUT)
#io.mode(LATCH_PIN, OUTPUT)
#io.mode(DATA_PIN, OUTPUT)

#io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN,[0,0,0,0,0,0,0,0])

sleep_time = 1.0/1.0

puts "starting up"
puts "all 1"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0])
sleep(sleep_time)
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [1,1,1,1,1,1,1,1])
sleep(sleep_time)
puts "1/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,1,1,1,1,1,1,1])
sleep(sleep_time)
puts "2/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,1,1,1,1,1,1])
sleep(sleep_time)
puts "3/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,1,1,1,1,1])
sleep(sleep_time)
puts "4/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,0,1,1,1,1])
sleep(sleep_time)
puts "5/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,0,0,1,1,1])
sleep(sleep_time)
puts "6/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,0,0,0,1,1])
sleep(sleep_time)
puts "7/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,0,0,0,0,1])
sleep(sleep_time)
puts "8/8"
io.shiftOutArray(DATA_PIN, CLOCK_PIN, LATCH_PIN, [0,0,0,0,0,0,0,0])

sleep(1)
