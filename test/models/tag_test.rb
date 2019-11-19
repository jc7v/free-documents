require 'test_helper'

class TagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'should not save without a name' do
    tag = Tag.new
    assert_not tag.save
  end

  test '#to_s return the name of the tag' do
    name = 'a name'
    tag = Tag.new(name: name)
    tag.save
    assert_equal tag.reload.to_s, name
  end
end
