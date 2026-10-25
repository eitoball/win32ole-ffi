# frozen_string_literal: true

begin
  require 'win32ole/ffi'
rescue LoadError
end
require 'test/unit'

if defined?(WIN32OLE) && Gem.win_platform?
  class TestTypeLibGC < Test::Unit::TestCase
    def test_survives_gc_between_repeated_type_and_typelib_construction
      dict = WIN32OLE.new('Scripting.Dictionary')
      # GC.start, not GC.stress: JRuby ignores GC.stress, and on CRuby it
      # makes every allocation a full GC, far too slow here.
      50.times do
        type = dict.ole_type
        GC.start
        tlib = type.ole_typelib
        assert_kind_of(WIN32OLE::Type, type)
        assert_kind_of(WIN32OLE::TypeLib, tlib)
      end
    end
  end
end
