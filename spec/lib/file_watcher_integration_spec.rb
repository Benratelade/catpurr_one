# frozen_string_literal: true

require "file_watcher"
require "spec_helper"

describe FileWatcher do
  after do
    temp_files = Dir["temp/*"]
    FileUtils.rm_r(temp_files, secure: true)
  end

  it "uploads each file that has been created in the temp folder" do
    FileWatcher.watch

    # Need to sleep before moving the files to make sure the listener
    # has started in its new thread
    sleep 1
    test_files = Dir["spec/fixtures/images/*"]
    FileUtils.cp(test_files, "/Users/benratelade/personal_projects/catpurr_one/temp")

    # It seems necessary to wait in order for the listener to
    # pick up the changes made to the directory.
    # The listener will only check for changes every 0.25s at best
    # See https://github.com/guard/listen#options
    sleep 1

    upload_job = FakeSidekiq.jobs_for_worker("Workers::FilesUploadWorker").first
    expect(upload_job["args"][0]["files"]).to contain_exactly(
      "#{temp_directory}cat.jpg",
      "#{temp_directory}cats.jpg",
      "#{temp_directory}dog.jpg",
    )
  end
end
