ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module MiniTest::Assertions

  def pdf_for_test
    File.expand_path('../fixtures/files/test.pdf', __FILE__ )
  end

  ##
  # Fails unless **exp** and *act* are both arrays and
  # contain the same elements.
  #
  #     assert_matched_arrays [3,2,1], [1,2,3]

  def assert_matched_arrays exp, act
    exp_ary = exp.to_ary
    assert_kind_of Array, exp_ary
    act_ary = act.to_ary
    assert_kind_of Array, act_ary
    assert_equal exp_ary.sort, act_ary.sort
  end

  ##
  # Assert *exp* collection contains the same elements of the *act* collection, the same number of times
  # A collection is an object responding to the method #each
  def assert_same_elements(exp, act)
    assert_equal(exp.length, act.length, "The expected and actual collection doesn't have the same size.
 We cannot assert that there is the same elements, the same number of times")
    assert(exp.respond_to?(:each), "expected collection doesn't have the method #each")
    assert(act.respond_to?(:each), "actual collection doesn't have the method #each")
    exp.each do |e|
      element_found = false
      act.each do |act_elem|
        if act_elem.eql? e
          element_found = true
          next
        end
      end
      assert(element_found, "Element #{e} of #{exp} does not exist in #{act}")
    end
  end
end


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