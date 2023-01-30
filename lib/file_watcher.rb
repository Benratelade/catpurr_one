# frozen_string_literal: true

require "listen"
require "aws_uploader"

module FileWatcher
  def self.watch
    aws_uploader = AWSUploader.new

    listener = Listen.to("./temp/") do |_modified, added, _removed|
      added.each do |new_file|
        aws_uploader.upload(file_path: new_file)
      end
    end

    Thread.new { listener.start }
  end
end
