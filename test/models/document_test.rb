require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  class ActiveSupport::TestCase::With
    def assert_not_save(method, value)
      d = documents(:doc1)
      d.doc_asset.attach(io: file_fixture('test.pdf').open, filename: 'test.pdf')
      super(d, method, value)
    end
  end

  def attach_asset(document)
    document.doc_asset.attach(io: file_fixture('test.pdf').open, filename: 'test.pdf')
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

    with.a 'nil asset' do
      assert_not documents(:doc1).save
    end
  end

  test 'author can be blank' do
    d = documents(:doc1)
    attach_asset d
    d.author = ''
    assert d.save
  end

  test 'number of pages has 0 value by default' do
    d = documents(:doc1)
    d.number_of_pages = nil
    attach_asset d
    d.save
    assert_equal 0, d.number_of_pages
  end

  test 'belongs to a user' do
    d = Document.new(title: 'asd')
    d.user = users(:user1)
    attach_asset d
    d.save
    assert_equal d.reload.user_id, users(:user1).id
  end

  test 'has many tags' do
    d = Document.new(title: 'title')
    d.user = users(:user1)
    attach_asset d
    doc_tags = tags(:tag1, :tag2, :tag3)
    d.tags  = doc_tags
    tag_ids = doc_tags.map {|t| t.id}
    d.save
    assert_equal(d.reload.tag_ids, tag_ids)
  end

  test 'order by user choice' do
    docs = Document.order_by(:updated_at_desc).all
    (docs.size - 1).times do |i|
      assert(docs[i].updated_at >= docs[i + 1].updated_at)
    end
    docs = Document.order_by(nil).all
    (docs.size - 1).times do |i|
      assert(docs[i].updated_at >= docs[i + 1].updated_at)
    end
     docs = Document.order_by('`sudo`').all
    (docs.size - 1).times do |i|
      assert(docs[i].updated_at >= docs[i + 1].updated_at)
    end
    docs = Document.order_by(:title_asc).all
    (docs.size - 1).times do |i|
      assert(docs[i].title < docs[i + 1].title)
    end
  end
end
