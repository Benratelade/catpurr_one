# frozen_string_literal: true

require "pry"
require_relative "./helpers/fake_sidekiq"

def file_fixture(fixture_name)
  File.expand_path(__dir__ + "/fixtures/images/#{fixture_name}")
end

def temp_directory
  CatpurrOne.root_directory + "/temp/"
end
