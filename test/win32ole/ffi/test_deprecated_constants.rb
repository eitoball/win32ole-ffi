# frozen_string_literal: true

require 'win32ole/ffi'
require 'test/unit'

class TestDeprecatedConstants < Test::Unit::TestCase
  {
    WIN32OLERuntimeError: 'WIN32OLE::RuntimeError',
    WIN32OLEQueryInterfaceError: 'WIN32OLE::QueryInterfaceError',
    WIN32OLE_TYPE: 'WIN32OLE::Type',
    WIN32OLE_TYPELIB: 'WIN32OLE::TypeLib',
    WIN32OLE_METHOD: 'WIN32OLE::Method',
    WIN32OLE_PARAM: 'WIN32OLE::Param',
    WIN32OLE_VARIABLE: 'WIN32OLE::Variable',
    WIN32OLE_VARIANT: 'WIN32OLE::Variant',
    WIN32OLE_EVENT: 'WIN32OLE::Event',
    WIN32OLE_RECORD: 'WIN32OLE::Record'
  }.each do |old_name, new_name|
    define_method("test_#{old_name}_is_#{new_name}") do
      EnvUtil.suppress_warning do
        assert_same(Object.const_get(new_name), Object.const_get(old_name))
      end
    end
  end
end
