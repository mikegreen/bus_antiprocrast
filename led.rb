#!/usr/bin/env ruby

# mike built this 2015-03-14

# require 'rest_client'
# require 'rexml/document'
# require 'stathat'
require 'require_all'
# require 'net/ftp'
# require 'date'
require 'net/http'
require_relative 'config/ba_config'
require 'rpi_gpio'


# t = DateTime.now

puts 'starting up...'

puts 'set pin numbering to bcm'
RPi::GPIO.set_numbering :bcm

PIN_NUM = 25

puts "setup pin as output"
RPi::GPIO.setup PIN_NUM, :as => :output
puts "set #{PIN_NUM} to high"
RPi::GPIO.set_high PIN_NUM

sleep(2)
RPi::GPIO.set_low PIN_NUM

puts 'pwm example'
PWM_FREQ = 10
pwm = RPi::GPIO::PWM.new(PIN_NUM,PWM_FREQ)


sleep_time = 1.0/10

puts "1-100 test"
(1..100).step(5) do |n|
	pwm.start n
	sleep(sleep_time)
	puts n
end

PWM_DUTY = 100

(1..100).step(5) do |n|
	PWM_DUTY += - 5
	puts PWM_DUTY
	pwm.start PWM_DUTY
	sleep(sleep_time)
end

puts 'Clean up...'
RPi::GPIO.clean_up

puts 'all done...'

