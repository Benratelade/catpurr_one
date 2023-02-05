# frozen_string_literal: true

require "file_watcher"
require "spec_helper"

describe FileWatcher do
  before do
    @listener = double("listener")
    allow(@listener).to receive(:start)
    allow(Listen).to receive(:to).and_return(@listener)

    @aws_uploader = double("aws uploader")
    allow(AWSUploader).to receive(:new).and_return(@aws_uploader)

    allow(Thread).to receive(:new)
  end

  it "starts a listener that looks at the temp directory and kicks off a new thread" do
    expect(Listen).to receive(:to).with("./temp/")
    expect(Thread).to receive(:new)

    FileWatcher.watch
  end
end
