# frozen_string_literal: true

require "#{__dir__}/../config/config.rb"
Dir["#{__dir__}/*.rb"].each do |file| 
  # need to do exclude whatever uses pi_piper on Mac. Macs don't have GPIO drivers. 
  require file unless file.match("motion_sensor_state_watcher.rb") 
end

module CatpurrOne
  def self.root_directory
    File.expand_path("#{__dir__}/..")
  end
end
