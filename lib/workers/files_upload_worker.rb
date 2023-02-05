require "catpurr_one"
require "sidekiq"
require "aws_uploader"

module Workers
  class FilesUploadWorker
    include Sidekiq::Job

    def perform(files: [])
      return if files.nil?

      aws_uploader = AWSUploader.new

      files.each do |file|
        aws_uploader.upload(file)
      end
    end
  end
end
