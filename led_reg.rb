#!/usr/bin/env ruby

# mike built this 2015-03-14

require 'wiringpi'

# Define GPIO pin numbers for the shift register connections
clock_pin = 4
latch_pin = 5
data_pin = 6

# Initialize the WiringPi GPIO interface
io = WiringPi::GPIO.new 

# Set the GPIO modes for the pins
io.mode(clock_pin, OUTPUT)
io.mode(latch_pin, OUTPUT)
io.mode(data_pin, OUTPUT)

# Define sleep time between operations
sleep_time = 1.0/4.0

# Start the sequence
puts "starting"

# Reset all shift register pins to low (0)
io.shiftOutArray(data_pin, clock_pin, latch_pin, [0,0,0,0,0,0,0,0])
sleep(1)

# Set all shift register pins to high (1)
io.shiftOutArray(data_pin, clock_pin, latch_pin, [1,1,1,1,1,1,1,1])
sleep(1)

# Set only the last two shift register pins to high (1)
io.shiftOutArray(data_pin, clock_pin, latch_pin, [0,0,0,0,0,0,1,1])
sleep(1)

# Read and display the status of the GPIO pins
puts "clock_pin: #{io.read(clock_pin)}"
puts "latch_pin: #{io.read(latch_pin)}"
puts "data_pin: #{io.read(data_pin)}"