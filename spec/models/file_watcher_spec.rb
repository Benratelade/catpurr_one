require "file_watcher"
require "spec_helper"

describe FileWatcher do
  before do
    @listener = double("listener")
    allow(@listener).to receive(:start)
    allow(Listen).to receive(:to).and_return(@listener)
  end

  it "raises an error if no block was passed" do
    expect do
      FileWatcher.watch
    end.to raise_error(ArgumentError, "A block must be provided")
  end

  it "starts a listener that looks at the temp directory" do
    new_files = double("newly added files")
    expect(Listen).to receive(:to).with("./temp/")
    expect(Thread).to receive(:new)

    FileWatcher.watch { |param| param }
  end
end
