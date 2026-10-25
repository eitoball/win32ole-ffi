# frozen_string_literal: true

begin
  require 'win32ole/ffi'
rescue LoadError
end
require 'test/unit'

ado_installed =
  if defined?(WIN32OLE) && Gem.win_platform?
    begin
      db = WIN32OLE.new('ADODB.Connection')
      db.connectionString = 'Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=.;'
      db.open
      db.close
      true
    rescue
    end
  end

if ado_installed
  class TestEventGC < Test::Unit::TestCase
    def test_survives_gc_between_advise_and_a_subsequent_event
      db = WIN32OLE.new('ADODB.Connection')
      db.connectionString = 'Driver={Microsoft Text Driver (*.txt; *.csv)};DefaultDir=.;'
      fired = false
      ev = WIN32OLE::Event.new(db, 'ConnectionEvents')
      ev.on_event('WillConnect') { fired = true }

      GC.start

      db.open
      WIN32OLE::Event.message_loop
      assert(fired, 'event callback did not fire after a forced GC between advise and the firing call')
    ensure
      ev&.unadvise
      db&.close if db&.state == 1
    end
  end
end
