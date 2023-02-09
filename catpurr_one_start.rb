require_relative "./lib/catpurr_one"

`echo 14 > /sys/class/gpio/unexport`

FileWatcher.watch

motion_sensor_state_watcher = MotionSensorStateWatcher.new
motion_sensor_state_watcher.start