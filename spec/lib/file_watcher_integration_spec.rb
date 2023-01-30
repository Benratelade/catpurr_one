require "file_watcher"
require "spec_helper"

describe FileWatcher do
  after do
    temp_files = Dir["temp/*"]
    FileUtils.rm_r(temp_files, secure: true)
  end

  it "executes the given block with the list of newly added files" do
    files_output = nil
    FileWatcher.watch do |added_files|
      files_output = added_files
    end

    # Need to sleep before moving the files to make sure the listener 
    # has started in its new thread
    sleep 1
    test_files = Dir["spec/fixtures/images/*"]
    FileUtils.cp(test_files, "/Users/benratelade/personal_projects/catpurr_one/temp")

    # It seems necessary to wait in order for the listener to 
    # pick up the changes made to the directory. 
    # The listener will only check for changes every 0.25s at best
    # See https://github.com/guard/listen#options
    sleep 3

    expect(files_output).to eq(
      [
        "/Users/benratelade/personal_projects/catpurr_one/temp/dog.jpg",
        "/Users/benratelade/personal_projects/catpurr_one/temp/cats.jpg",
        "/Users/benratelade/personal_projects/catpurr_one/temp/cat.jpg",
      ],
    )
  end
end
