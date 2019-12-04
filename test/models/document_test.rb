require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  class ActiveSupport::TestCase::With
    def assert_not_save(method, value)
      d = documents(:doc1)
      d.doc_asset.attach(io: file_fixture('test.pdf').open, filename: 'test.pdf')
      super(d, method, value)
    end
  end

  def attach_asset_to(document)
    document.doc_asset.attach(io: file_fixture('test.pdf').open, filename: 'test.pdf')
  end

  def add_tags_and_save(document, tags = [])
    document.tags = tags
    document.user = users(:user1)
    attach_asset_to document
    document.save
  end

  def to_ids(collection)
    collection.map {|e| e.id}
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
    attach_asset_to d
    d.author = ''
    assert d.save
  end

  test 'number of pages has 0 value by default' do
    d = documents(:doc1)
    d.number_of_pages = nil
    attach_asset_to d
    d.save
    assert_equal 0, d.number_of_pages
  end

  test 'belongs to a user' do
    d = Document.new(title: 'asd')
    d.user = users(:user1)
    attach_asset_to d
    d.save
    assert_equal d.reload.user_id, users(:user1).id
  end

  test 'has many tags' do
    d = Document.new(title: 'title')
    doc_tags = tags(:tag1, :tag2, :tag3)
    add_tags_and_save(d, doc_tags)
    assert_equal(d.reload.tag_ids, to_ids(doc_tags))
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

  test 'includes attachments and blobs' do
    # TODO write test
    assert_equal(50, Document.include_blobs.size)
  end

  test 'find the document having the given tags' do
    doc_tags = [Tag.create!(name: 'qqq'), Tag.create!(name: 'aaa')]
    d1 = documents(:doc1)
    add_tags_and_save(d1, doc_tags)
    assert_same_elements [d1], Document.filter_by_tags(to_ids(doc_tags))
  end

  test 'find the document with one of them attributed tags' do
    doc_tags = [Tag.create!(name: 'qqq'), Tag.create!(name: 'aaa')]
    d1 = documents(:doc1)
    add_tags_and_save(d1, doc_tags)
    assert_same_elements [d1], Document.filter_by_tags(to_ids([doc_tags.first]))
  end

  test 'find the two documents having one tag in commons' do
    doc_tags = [Tag.create!(name: 'qqq'), Tag.create!(name: 'aaa')]
    d1 = documents(:doc1)
    add_tags_and_save(d1, doc_tags)
    d2 = documents(:doc2)
    add_tags_and_save(d2, [doc_tags.first])
    assert_same_elements [d1, d2], Document.filter_by_tags([doc_tags.first.id])
  end

  test 'find all documents with tags nil or empty' do
    assert_equal Document.filter_by_tags(nil), Document.all
    assert_equal Document.filter_by_tags([]), Document.all
  end

  test 'Find all documents having one or more of the given tags in common' do
    docs = documents(:doc3, :doc4, :doc5)
    tags = [Tag.create!(name: 'qqq'), Tag.create!(name: 'aaa')]
    docs.each { |d| add_tags_and_save(d, tags) }
    d1 = documents(:doc1)
    add_tags_and_save(d1, [tags.first])
    assert_same_elements docs << d1, Document.filter_by_tags(to_ids(tags))
  end
end
