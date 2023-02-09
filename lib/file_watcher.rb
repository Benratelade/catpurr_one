# frozen_string_literal: true

require_relative "./catpurr_one"
require "listen"
require_relative "./workers/files_upload_worker"
require_relative "./aws_uploader"

module FileWatcher
  def self.watch
    listener = Listen.to("./temp/") do |_modified, added, _removed|
      Workers::FilesUploadWorker.perform_async("files" => added) if added.any?
    end

    Thread.new { listener.start }
  end
end
