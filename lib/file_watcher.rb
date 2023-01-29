require "listen"

module FileWatcher
  def self.watch
    raise(ArgumentError, "A block must be provided") unless block_given?

    listener = Listen.to("./temp/") do |_modified, added, _removed|
      yield(added) if added.any?
    end

    Thread.new { listener.start }
  end
end
