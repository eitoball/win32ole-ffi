# win32ole-ffi

WIN32OLE implemented in pure Ruby with Fiddle, without a C extension, so
that it also runs on JRuby. It works on Windows only, and is tested with
CRuby 2.6+ (mswin and mingw) and JRuby 9.4+.

It provides the same API as [ruby/win32ole](https://github.com/ruby/win32ole)
(`WIN32OLE`, `WIN32OLE::Type`, `WIN32OLE::Event`, ...) and runs that gem's
test suite. Use one or the other: both define the `WIN32OLE` class, so do
not load `win32ole` and `win32ole/ffi` in the same process.

## Installation

```ruby
gem 'win32ole-ffi'
```

The gem depends on the `fiddle` gem on CRuby and on the `ffi` gem (which
JRuby's Fiddle runs on) on JRuby.

## Usage

Require `win32ole/ffi` where you would require `win32ole`:

```ruby
require 'win32ole/ffi'

dict = WIN32OLE.new('Scripting.Dictionary')
dict.add('ruby', 'Ruby')
dict.item('ruby') #=> "Ruby"
```

`WIN32OLE::Property`, the helper that ruby/win32ole's `olegen.rb`-generated
code uses, is not included.

## Development

    $ git clone --recurse-submodules https://github.com/eitoball/win32ole-ffi
    $ bundle install
    $ bundle exec rake test

`rake test` also runs ruby/win32ole's tests from the `vendor/win32ole`
submodule. Before that it applies `patches/*.patch` to the submodule's
working tree; `rake test:unpatch` reverts them.

## License

The same as ruby/win32ole: Ruby's license or BSD-2-Clause (see `COPYING`
and `BSDL`).
