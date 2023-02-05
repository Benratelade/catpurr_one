# frozen_string_literal: true

require "catpurr_one"
require "listen"
require "workers/files_upload_worker"
require "aws_uploader"

module FileWatcher
  def self.watch
    listener = Listen.to("./temp/") do |_modified, added, _removed|
      Workers::FilesUploadWorker.perform_async("files" => added) if added.any?
    end

    Thread.new { listener.start }
  end
end
