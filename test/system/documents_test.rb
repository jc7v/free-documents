require "application_system_test_case"
# include Devise::Test::IntegrationHelpers

class DocumentsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @document = documents(:doc1)
  end

  test "visiting the index" do
    visit root_url
    assert_selector "h1", text: "Listing all documents"
  end

  test "creating a Document" do
    visit root_url
    sign_in users(:user1)
    click_on "Upload"
    attach_file  pdf_for_test
    click_on "Create Document"
    assert_text 'Edit:'
    click_on "Create Document"
    assert_text 'Document successfully created'
  end

  test 'List all documents uploaded by the current user' do
    user = users(:user1)
    sign_in user
    d = documents(:doc1)
    visit document_user_path(d.id)
  end

  test "updating a Document" do
    user = users(:user1)
    sign_in user
    d = documents(:doc1)
    visit document_user_path(d.id)
    click_on "Edit", match: :first

    click_on "Update Document"

    assert_text "Document was successfully updated"
    click_on "Back"
  end

  test "destroying a Document" do
    visit documents_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Document was successfully destroyed"
  end
end
