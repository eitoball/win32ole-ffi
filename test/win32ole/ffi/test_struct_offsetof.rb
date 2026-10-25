# frozen_string_literal: true

require 'test/unit'
require 'win32ole/ffi/typeinfo'

class TestStructOffsetof < Test::Unit::TestCase
  TI = WIN32OLE::TypeInfo

  # Fiddle::CStruct.offsetof is fiddle 1.1+; layout_offsetof stands in for it
  # on older fiddle (Ruby 2.6-3.0's 1.0.x), so it must agree wherever both exist.
  def test_layout_offsetof_matches_fiddle_offsetof
    omit('needs fiddle 1.1+ to compare against') unless TI::FUNCDESC.respond_to?(:offsetof)

    [TI::GUID, TI::TYPEDESC, TI::ELEMDESC, TI::FUNCDESC, TI::VARDESC, TI::TYPEATTR].each do |struct|
      struct.members.each do |name|
        assert_equal(struct.offsetof(name), TI.layout_offsetof(struct, name), name)
      end
    end
  end

  # Ruby 2.6/2.7's fiddle structs don't even have types and members.
  def test_layout_offsetof_works_on_any_fiddle
    assert_equal(0, TI.layout_offsetof(TI::FUNCDESC, 'memid'))
    assert_equal(TI::FUNCDESC.size - 8, TI.layout_offsetof(TI::FUNCDESC, 'wFuncFlags'))
  end
end
