# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

UPSTREAM = "vendor/win32ole"

namespace :test do
  desc "Apply patches/*.patch to #{UPSTREAM} (skips ones already applied)"
  task :patch do
    # Without this, `git -C` on the empty directory acts on this repository instead.
    unless File.exist?(File.join(UPSTREAM, ".git"))
      abort "#{UPSTREAM} is not checked out; run `git submodule update --init`"
    end
    Dir["patches/*.patch"].sort.each do |patch|
      path = File.expand_path(patch)
      next if system("git", "-C", UPSTREAM, "apply", "--reverse", "--check", path, err: File::NULL)
      sh "git", "-C", UPSTREAM, "apply", path
    end
  end

  desc "Revert #{UPSTREAM} to its pinned state"
  task :unpatch do
    sh "git", "-C", UPSTREAM, "checkout", "--", "."
  end
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test/lib"
  t.libs << "lib"
  t.ruby_opts << "-rhelper"
  t.test_files = FileList["#{UPSTREAM}/test/win32ole/test_*.rb", "test/**/test_*.rb"]
end
task :test => "test:patch"

task :default => :test
