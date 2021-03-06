require 'test_helper'

class ConnectingTest < ActiveSupport::TestCase

  def setup
    @page = Factory(:page, :section => root_section)
    @block = Factory(:html_block, :name => "Versioned Content Block")
    @page.create_connector(@block, "main")
    reset(:page, :block)
  end

  test "Update connected pages should return true if there is a valid version." do
    block = Cms::HtmlBlock.new
    mock_draft = mock()
    mock_draft.expects(:version).returns(1)
    block.expects(:draft).returns(mock_draft)

    assert_equal true, block.update_connected_pages
  end

  test "Connected_to" do
    assert_equal 1, @block.version
    pages = Cms::Page.connected_to(:connectable => @block, :version => @block.version).all
    assert_equal @page, pages.first
  end

  test "connected_pages should return all pages connected to a versioned block " do
    @page.publish!
    assert_equal [@page], @block.connected_pages
  end


  test "connected_pages should return all pages connected to a nonversioned block " do
    @portlet = Factory(:portlet)
    @page.create_connector(@portlet, "main")
    @page.publish!
    assert_equal [@page], @portlet.connected_pages
  end
end