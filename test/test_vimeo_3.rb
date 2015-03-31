require 'minitest/autorun'
require 'vimeo_3'

class Vimeo3Test < Minitest::Test
  def test_starting
    puts

    expected = {:clientID=>"id", :clientSecret=>"secret", :accessToken=>nil}
    assert_equal expected,
      Vimeo3.new('id', 'secret').getValues
  end

  def test_saving_token
    expected = {:clientID=>"id", :clientSecret=>"secret", :accessToken=>"token"}
    assert_equal expected,
      Vimeo3.new('id', 'secret', {:accessToken => 'token'}).getValues
  end

  def test_upload
    # TO-DO: Receive arguments for test.
    upload = Vimeo3.new('id', 'secret', {:accessToken => 'token'}).getForm('http://test.me/')

    assert_includes(upload, "uri")
    assert_includes(upload, "ticket_id")
    assert_includes(upload, "user")
    assert_includes(upload, "upload_link_secure")
    assert_includes(upload, "form")
  end
end
