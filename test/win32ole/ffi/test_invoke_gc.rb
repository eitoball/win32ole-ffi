# frozen_string_literal: true

begin
  require 'win32ole/ffi'
rescue LoadError
end
require 'test/unit'

if defined?(WIN32OLE) && Gem.win_platform?
  class TestInvokeGC < Test::Unit::TestCase
    def test_survives_gc_between_repeated_invokes
      dict = WIN32OLE.new('Scripting.Dictionary')
      # GC.start, not GC.stress: JRuby ignores GC.stress, and on CRuby it
      # makes every allocation a full GC, far too slow here.
      100.times do |i|
        dict.add("key#{i}", i)
        GC.start
        assert_equal(i, dict.item("key#{i}"))
      end
    end
  end
end
