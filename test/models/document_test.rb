require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  class ActiveSupport::TestCase::With
    def assert_not_save(method, value)
      super(documents(:doc1), method, value)
    end
  end

  should_not_save do |with|
    with.an 'empty title' do
      assert_not_save :title=, ''
    end

    with.a 'number of pages < 1' do
      assert_not_save :number_of_pages=, -1
    end

    with.a 'author name > 50' do
      assert_not_save :author=, 'a' * 51
    end

    with.a 'realization date in the future' do
      assert_not_save :realized_at=, Date.today + 1.day
    end

    with.a 'nil user' do
      assert_not_save :user=, nil
    end
  end

  test 'author can be blank' do
    d = documents(:doc1)
    d.author = ''
    assert d.save
  end

  test 'Document has a user' do
    d = Document.new(title: 'asd', number_of_pages: 1)
    d.user = users(:user1)
    d.save!
    assert d.reload.user_id = users(:user1).id
  end


end
