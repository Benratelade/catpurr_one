# frozen_string_literal: true

require "motion_sensor_state_watcher"
require "spec_helper"

describe MotionSensorStateWatcher do
  before do
    allow(CatpurrOne).to receive(:root_directory).and_return("root-directory")
    allow(PiPiper).to receive(:wait)
  end
  describe "#intialize" do
    it "sets the destination folder for images" do
      expect(CatpurrOne).to receive(:root_directory)
      expect(MotionSensorStateWatcher.new.destination_folder).to eq("root-directory/temp/")
    end
  end

  describe "#start" do
    it "watches a pin and waits" do
      state_watcher = MotionSensorStateWatcher.new
      expect(PiPiper).to receive(:wait)
      expect(state_watcher).to receive(:after).with(pin: 14, goes: :high, direction: :in)

      state_watcher.start
    end
  end
end
