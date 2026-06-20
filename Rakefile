$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'zap/version'
GEMSPEC = Gem::Specification.load('zap.gemspec')

require 'rubygems/package_task'
Gem::PackageTask.new(GEMSPEC) do |pkg|
end

gem 'rake-compiler', '~> 0.9'
require 'rake/extensiontask'
Rake::ExtensionTask.new('zap', GEMSPEC) do |ext|
  ext.ext_dir = 'ext/zap'
  ext.lib_dir = 'lib/zap'
  ext.source_pattern = "*.{cc,h}"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError, NoMethodError => e
  desc 'Run RSpec code examples'
  task :spec do
    abort "rspec is unavailable on this Ruby (#{e.class}: #{e.message}). " \
          "Install a compatible rspec and re-run, or run the examples directly."
  end
end

task :default => [:compile, :spec]

Rake::Task["clean"].clear
desc "Clean build artifacts"
task :clean do
  rm_r "tmp" rescue nil
  rm_r "pkg" rescue nil
  rm "lib/zap/zap.bundle" rescue nil
end

desc "Tag commit, push to repo, then push to RubyGems"
task :release => [:clean, :compile, :spec, :gem]  do
  tag = "v#{Zap::VERSION}"
  sh "git tag #{tag}"
  sh "git push origin #{tag}"
  sh "gem push pkg/zap-#{Zap::VERSION}.gem"
end

desc "Open an irb console"
task :console do
  $: << File.expand_path("../lib", __FILE__)
  require 'irb'
  require 'zap'
  ARGV.clear
  IRB.start
end
