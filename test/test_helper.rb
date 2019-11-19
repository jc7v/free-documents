ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def self.snv(test_name)
    'Should not save with ' + test_name
  end

  def self.should_not_save(&block)
    block.call(With)
  end

  def assert_not_save(record, method, value)
    record.try(method, value)
    assert_not(record.save)
  end

  class With < ActiveSupport::TestCase
    def self.a(name, &block)
      self.an(name, &block)
    end

    def self.an(name, &block)
      test('should not save with ' + name, &block)
    end
  end
end