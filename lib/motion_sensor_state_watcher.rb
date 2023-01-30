# frozen_string_literal: true

require "pi_piper"
include PiPiper

last_picture_time = nil
after pin: 14, goes: :high, direction: :in do |pin|
  pin.read
  puts "IR sensor triggered! Taking a snap..."
  puts "Pin 14 value: #{pin.value}. Old value: #{pin.last_value}"
  time = Time.now.to_i
  current_path = __dir__
  result = `libcamera-still -n -o #{current_path}/../temp/#{time}.jpg --hdr=0`
  puts result
  puts "completed taking photo!"
  puts "Last picture was taken: #{time - last_picture_time}s ago" if last_picture_time
  last_picture_time = time
  pin.read
  puts "Pin value: #{pin.value}"
end

PiPiper.wait
