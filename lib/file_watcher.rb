# frozen_string_literal: true

require "listen"
require "aws_uploader"

module FileWatcher
  def self.watch
    aws_uploader = AWSUploader.new

    listener = Listen.to("./temp/") do |_modified, added, _removed|
      added.each do |new_file|
        # Probably a better way of doing this would be to add these to a queue for processing.
        # That would be MUCH easier to test (no need to actually connect to aws in the test, for one thing)
        aws_uploader.upload(file_path: new_file)
      end
    end

    Thread.new { listener.start }
  end
end
