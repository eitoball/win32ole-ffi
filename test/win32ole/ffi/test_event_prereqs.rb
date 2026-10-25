# frozen_string_literal: true

begin
  require 'win32ole/ffi'
rescue LoadError
end
require 'test/unit'

require 'win32ole/ffi/win32ole'

class TestEventPrereqs < Test::Unit::TestCase
  def test_connect_raises_not_implemented_for_non_nil_host
    assert_raise(NotImplementedError) { WIN32OLE.connect('Scripting.Dictionary', 'remotehost') }
  end
end
