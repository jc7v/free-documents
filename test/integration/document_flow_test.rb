require 'test_helper'

class DocumentFlowTest < ActionDispatch::IntegrationTest
  test 'see the root path listing documents' do
    get '/'
    assert_select 'h1', 'Documents'
  end
end
