require "catpurr_one"

FileWatcher.watch

motion_sensor_state_watcher = MotionSensorStateWatcher.new
motion_sensor_state_watcher.start