# frozen_string_literal: true

require 'test/unit'
require 'win32ole/ffi'

# Like the C extension's OLE_FREE, a finalizer Releases only on a thread that
# has initialized OLE: GC may run it on any thread, including the main thread
# at exit after the object's apartment is gone, and JRuby runs every
# finalizer on a thread of its own. There the Release waits for the next
# thread with OLE instead of leaking.
class TestFinalizerThread < Test::Unit::TestCase
  PTR = 0x1234

  def setup
    @released = []
    release_fn = ->(ptr) { @released << ptr }
    @finalizers = [
      WIN32OLE.finalizer(PTR, release_fn),
      WIN32OLE::Type.finalizer(PTR, release_fn),
      WIN32OLE::TypeLib.finalizer(PTR, release_fn),
      WIN32OLE::Record.finalizer({ pri: PTR, buffer_ptr: nil }, release_fn)
    ]
  end

  def on_thread(ole_initialized)
    Thread.new do
      Thread.current.thread_variable_set(:win32ole_ole_initialized, true) if ole_initialized
      yield
    end.join
  end

  def test_releases_on_an_ole_initialized_thread
    on_thread(true) { @finalizers.each(&:call) }
    assert_equal([PTR] * 4, @released)
  end

  def test_defers_release_on_a_thread_without_ole_to_one_with_ole
    on_thread(false) { @finalizers.each(&:call) }
    assert_equal([], @released)

    on_thread(true) { WIN32OLE::Win32.run_deferred_releases }
    assert_equal([PTR] * 4, @released)
  end

  def test_ole_initialize_runs_deferred_releases
    omit('needs OLE') unless Gem.win_platform?

    on_thread(false) { @finalizers.each(&:call) }
    WIN32OLE.ole_initialize
    assert_equal([PTR] * 4, @released)
  end
end
