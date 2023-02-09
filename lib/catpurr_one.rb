# frozen_string_literal: true

require "#{__dir__}/../config/config.rb"
Dir["#{__dir__}/*.rb"].each do |file|
  require file
end

module CatpurrOne
  def self.root_directory
    File.expand_path("#{__dir__}/..")
  end
end
