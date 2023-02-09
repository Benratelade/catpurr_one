# frozen_string_literal: true

require "workers/files_upload_worker"
require "spec_helper"

describe Workers::FilesUploadWorker do
  before do
    @aws_uploader = double("aws uploader")
    allow(AWSUploader).to receive(:new).and_return(@aws_uploader)
    allow(@aws_uploader).to receive(:upload)
    @worker = Workers::FilesUploadWorker.new
  end

  it "does nothing if files are nil" do
    expect(@worker.perform(files: nil)).to eq(nil)
  end

  it "uses AWS S3 to upload the files" do
    files = %w[file-1 file-2]
    expect(@aws_uploader).to receive(:upload).with("file-1")
    expect(@aws_uploader).to receive(:upload).with("file-2")

    @worker.perform(files: files)
  end
end
