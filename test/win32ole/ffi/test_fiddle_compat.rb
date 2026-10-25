# frozen_string_literal: true

require 'test/unit'
require 'win32ole/ffi/win32'

# What this implementation relies on from Fiddle, which JRuby's older FFI
# backends (fiddle 1.1.4 in JRuby 9.4, 1.1.6 in JRuby 10.0) don't provide.
class TestFiddleCompat < Test::Unit::TestCase
  T = Fiddle

  def test_function_takes_an_integer_address_for_a_voidp_argument
    received = nil
    closure = T::Closure::BlockCaller.new(T::TYPE_INTPTR_T, [T::TYPE_VOIDP]) { |ptr| received = ptr.to_i }
    T::Function.new(closure, [T::TYPE_VOIDP], T::TYPE_INTPTR_T).call(0x1234)
    assert_equal(0x1234, received)
  end

  def test_closure_receives_a_fiddle_pointer
    received = nil
    closure = T::Closure::BlockCaller.new(T::TYPE_INTPTR_T, [T::TYPE_VOIDP]) { |ptr| received = ptr; 0 }
    T::Function.new(closure, [T::TYPE_VOIDP], T::TYPE_INTPTR_T).call(T::Pointer.new(0x1234))
    assert_kind_of(T::Pointer, received)
    assert_equal(0x1234, received.to_i)
  end

  # Writing the String puts a NUL after its bytes; fiddle < 1.1.8 allocated
  # only bytesize, one byte short (heap corruption on Windows).
  def test_to_ptr_of_a_string_has_room_for_the_terminating_nul
    omit('JRuby FFI backend only') unless RUBY_ENGINE == 'jruby'
    ffi_ptr = T::Pointer.to_ptr('abcd').instance_variable_get(:@ffi_ptr)
    assert_predicate(ffi_ptr, :size_limit?)
    assert_operator(ffi_ptr.size, :>=, 5)
  end
end
