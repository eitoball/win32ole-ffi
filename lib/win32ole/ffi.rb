# frozen_string_literal: true

require 'win32ole/ffi/win32ole'
require 'win32ole/ffi/type'
require 'win32ole/ffi/typelib'
require 'win32ole/ffi/event'

# ext/win32ole keeps the old toplevel class names as deprecated aliases, so
# existing scripts that use them still run here but get a warning to move to
# the WIN32OLE:: names.
{
  WIN32OLE_TYPE: WIN32OLE::Type,
  WIN32OLE_TYPELIB: WIN32OLE::TypeLib,
  WIN32OLE_METHOD: WIN32OLE::Method,
  WIN32OLE_PARAM: WIN32OLE::Param,
  WIN32OLE_VARIABLE: WIN32OLE::Variable,
  WIN32OLE_VARIANT: WIN32OLE::Variant,
  WIN32OLE_EVENT: WIN32OLE::Event,
  WIN32OLE_RECORD: WIN32OLE::Record
}.each do |name, klass|
  Object.const_set(name, klass)
  Object.deprecate_constant(name)
end

class WIN32OLE

  #
  # By overriding Object#methods, WIN32OLE might
  # work well with did_you_mean gem.
  # This is experimental.
  #
  #  require 'win32ole/ffi'
  #  dict = WIN32OLE.new('Scripting.Dictionary')
  #  dict.Ade('a', 1)
  #  #=> Did you mean?  Add
  #
  def methods(*args)
    super + ole_methods_safely.map(&:name).map(&:to_sym)
  end

  private

  def ole_methods_safely
    ole_methods
  rescue WIN32OLE::QueryInterfaceError, NameError
    []
  end
end
