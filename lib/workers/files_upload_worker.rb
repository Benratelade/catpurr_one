# frozen_string_literal: true

require_relative "../catpurr_one"
require_relative "../aws_uploader"
require "sidekiq"

module Workers
  class FilesUploadWorker
    include Sidekiq::Job

    def perform(files = [])
      return if files.nil?

      aws_uploader = AWSUploader.new

      files.each do |file|
        aws_uploader.upload(file_path: file)
      end
    end
  end
end
