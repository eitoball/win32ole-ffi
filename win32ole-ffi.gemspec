# frozen_string_literal: true

require_relative "lib/win32ole/ffi/version"

Gem::Specification.new do |spec|
  spec.name          = "win32ole-ffi"
  spec.version       = Win32OLEFFI::VERSION
  spec.authors       = ["Eito Katagiri"]
  spec.email         = ["eitoball@gmail.com"]

  spec.summary       = %q{WIN32OLE implemented in pure Ruby with Fiddle}
  spec.description   = %q{A WIN32OLE for Windows written in pure Ruby on top of Fiddle instead of a C extension, so that it also runs on JRuby.}
  spec.homepage      = "https://github.com/eitoball/win32ole-ffi"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")
  spec.licenses      = ["Ruby", "BSD-2-Clause"]

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = IO.popen(%w[git ls-files -z -- lib sig README.md CHANGELOG.md COPYING BSDL], chdir: __dir__, err: IO::NULL, exception: false, &:read).split("\x0")
  spec.require_paths = ["lib"]

  # One gem per platform: JRuby's own Fiddle runs on the ffi gem and the
  # fiddle gem cannot be built there, while CRuby 3.5+ no longer ships
  # fiddle as a default gem.
  if RUBY_ENGINE == "jruby"
    spec.platform = "java"
    spec.add_dependency "ffi", "~> 1.0"
  else
    spec.add_dependency "fiddle", "~> 1.0"
  end
end
