# frozen_string_literal: true

require "file_watcher"
require "spec_helper"

describe FileWatcher do
  before do
    credentials = Aws::Credentials.new(
      ENV.fetch("AWS_ACCESS_KEY_ID", nil),
      ENV.fetch("AWS_SECRET_ACCESS_KEY", nil),
    )
    @s3_client = Aws::S3::Client.new(
      region: CatpurrOne::Config::AWS_REGION,
      credentials: credentials,
    )
  end

  after do
    temp_files = Dir["temp/*"]
    FileUtils.rm_r(temp_files, secure: true)
  end

  it "uploads each file that has been created in the temp folder" do
    expect(
      @s3_client.list_objects(
        {
          bucket: CatpurrOne::Config::AWS_S3_BUCKET_NAME,
          prefix: "unprocessed",
        },
      ).contents.map(&:key),
    ).to eq([])
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
    sleep 10

    expect(
      @s3_client.list_objects(
        {
          bucket: CatpurrOne::Config::AWS_S3_BUCKET_NAME,
          prefix: "unprocessed/",
        },
      ).contents.map(&:key),
    ).to eq(
      [
        "unprocessed/cat.jpg",
        "unprocessed/cats.jpg",
        "unprocessed/dog.jpg",
      ],
    )
  end
end
