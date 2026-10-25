# frozen_string_literal: true

require 'test/unit'
require 'rbconfig'

class TestEntryPoint < Test::Unit::TestCase
  LIB = File.expand_path('../../../lib', __dir__)

  # A subprocess, because other test files may already have defined WIN32OLE here.
  # Single quotes: JRuby on Windows mangles an argument holding both spaces
  # and double quotes.
  def defined_after_require(feature)
    IO.popen([RbConfig.ruby, '-I', LIB, '-e', "require '#{feature}'; print defined?(WIN32OLE).inspect"], &:read)
  end

  def test_require_win32ole_ffi_defines_the_class_on_any_host
    assert_equal('"constant"', defined_after_require('win32ole/ffi'))
  end
end
