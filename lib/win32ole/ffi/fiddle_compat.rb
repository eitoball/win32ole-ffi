# frozen_string_literal: true

require 'fiddle'

# Backports, for JRuby's older Fiddle FFI backends, behaviours this
# implementation relies on and newer fiddle already has. JRuby 9.4 ships
# fiddle 1.1.4, 10.0 ships 1.1.6, and 10.1 ships 1.1.8, which needs none of
# this. CRuby's C fiddle has always behaved this way.
if RUBY_ENGINE == 'jruby'
  class WIN32OLE
    module FiddleCompat
      FIDDLE_VERSION = Gem::Version.new(Fiddle::VERSION)

      # fiddle 1.1.6: an Integer address passed for a VOIDP argument.
      module IntegerVoidp
        def call(*args, &block)
          @args.each_with_index do |type, i|
            args[i] = Fiddle::Pointer.new(args[i]) if type == Fiddle::TYPE_VOIDP && args[i].is_a?(Integer)
          end
          super
        end
      end

      # fiddle 1.1.8: a closure's pointer arguments as Fiddle::Pointer, not FFI::Pointer.
      module FiddlePointerArgs
        def call(*args)
          super(*args.map { |v| v.is_a?(FFI::Pointer) ? Fiddle::Pointer.new(v) : v })
        end
      end

      # fiddle 1.1.8: Pointer.to_ptr(a_string) with room for the NUL written
      # after the bytes (older ones malloc only bytesize, overrunning the heap).
      module StringToPtr
        def to_ptr(value)
          return super unless value.is_a?(String)

          new(FFI::MemoryPointer.from_string(value), value.bytesize)
        end
        alias [] to_ptr
      end

      Fiddle::Function.prepend(IntegerVoidp) if FIDDLE_VERSION < Gem::Version.new('1.1.6')
      if FIDDLE_VERSION < Gem::Version.new('1.1.8')
        Fiddle::Closure::BlockCaller.prepend(FiddlePointerArgs)
        Fiddle::Pointer.singleton_class.prepend(StringToPtr)
      end
    end
  end
end
