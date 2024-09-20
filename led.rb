#!/usr/bin/env ruby

# mike built this 2015-03-14

# Required libraries for the script
require 'require_all'
require 'net/http'
require_relative 'config/ba_config'
require 'rpi_gpio'

# Starting the script, initializing GPIO
puts 'starting up...'

# Set the GPIO pin numbering system to BCM (Broadcom SOC channel)
puts 'set pin numbering to bcm'
RPi::GPIO.set_numbering :bcm

# Define the GPIO pin number that will be used
PIN_NUM = 25

# Setup the specified GPIO pin as an output
puts "setup pin as output"
RPi::GPIO.setup PIN_NUM, :as => :output

# Set the GPIO pin to high (power on)
puts "set #{PIN_NUM} to high"
RPi::GPIO.set_high PIN_NUM

# Wait for 2 seconds
sleep(2)

# Set the GPIO pin to low (power off)
RPi::GPIO.set_low PIN_NUM

# Demonstrating PWM (Pulse Width Modulation) control
puts 'pwm example'
PWM_FREQ = 10  # Set PWM frequency to 10 Hz
pwm = RPi::GPIO::PWM.new(PIN_NUM, PWM_FREQ)  # Initialize PWM on the specified pin with the frequency

# Define sleep time for PWM modulation
sleep_time = 1.0 / 10

# Gradually increase PWM duty cycle from 1% to 100% in steps of 5%
puts "1-100 test"
(1..100).step(5) do |n|
  pwm.start n
  sleep(sleep_time)
  puts n
end

# Reset PWM duty cycle to 100%
PWM_DUTY = 100

# Gradually decrease PWM duty cycle from 100% to 0% in steps of 5%
(1..100).step(5) do |n|
  PWM_DUTY += -5
  puts PWM_DUTY
  pwm.start PWM_DUTY
  sleep(sleep_time)
end

# Clean up by resetting all GPIO pins used by this script
puts 'Clean up...'
RPi::GPIO.clean_up

# Script complete
puts 'all done...'