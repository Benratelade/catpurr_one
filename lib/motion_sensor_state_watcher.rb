# frozen_string_literal: true

require "catpurr_one"
# require "pi_piper"
# include PiPiper

class MotionSensorStateWatcher
  attr_reader :destination_folder

  def initialize
    @destination_folder = "#{CatpurrOne.root_directory}/temp/"
  end

  def start
    after pin: 14, goes: :high, direction: :in do |_pin|
      puts "IR sensor triggered! Taking a snap..."

      time = Time.now.to_i
      result = `libcamera-still -n -o #{@destination_folder}/#{time}.jpg --hdr=0`

      puts "completed taking photo!"
    end

    PiPiper.wait
  end
end
