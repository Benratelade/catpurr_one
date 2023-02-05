require "sidekiq/testing"

Sidekiq.configure_server do |config|
  config.logger = nil
end

Sidekiq.configure_client do |config|
  config.logger = nil
end

module FakeSidekiq
  def self.count
    Sidekiq::Worker.jobs.count
  end

  def self.jobs_for_worker(worker_name)
    jobs = self.jobs.filter do |job|
      job["class"] == worker_name
    end
  end

  def self.jobs
    Sidekiq::Worker.jobs
  end
end