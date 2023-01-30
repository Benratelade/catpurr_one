# frozen_string_literal: true

require "pry"

def file_fixture(fixture_name)
  File.expand_path(__dir__ + "/fixtures/images/#{fixture_name}")
end
