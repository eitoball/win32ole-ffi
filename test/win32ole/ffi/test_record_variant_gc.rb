# frozen_string_literal: true

begin
  require 'win32ole/ffi'
rescue LoadError
end
require 'test/unit'

if defined?(WIN32OLE) && Gem.win_platform?
  class TestRecordVariantGC < Test::Unit::TestCase
    def test_survives_gc_between_repeated_variant_array_construction
      dict = WIN32OLE.new('Scripting.Dictionary')
      dict.add('a', 1)
      dict.add('b', 2)
      # GC.start, not GC.stress: JRuby ignores GC.stress, and on CRuby it
      # makes every allocation a full GC, far too slow here.
      50.times do
        keys = dict.Keys
        GC.start
        items = dict.Items
        assert_kind_of(Array, keys)
        assert_kind_of(Array, items)
      end
    end
  end
end
