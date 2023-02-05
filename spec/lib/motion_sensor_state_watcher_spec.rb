# frozen_string_literal: true

require "motion_sensor_state_watcher"
require "spec_helper"

describe MotionSensorStateWatcher do
  describe "#intialize" do
    it "sets the destination folder for images" do
      expect(MotionSensorStateWatcher.new.destination_folder).to eq("#{CatpurrOne.root_directory}/temp/")
    end
  end
end