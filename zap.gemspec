require File.expand_path('../lib/zap/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'zap'
  s.license = 'MIT'

  s.version = Zap::VERSION

  s.required_ruby_version = '>= 2.0.0'

  s.summary = "ZAP serialization bindings for Ruby."

  s.description =
    "Ruby bindings for ZAP: an insanely fast binary data interchange " \
    "format and capability-based RPC system. Think JSON, except binary. " \
    "Or think Protocol Buffers, except faster. " \
    "The native extension links the ZAP C++ runtime (currently the " \
    "upstream libcapnp build; see README)."

  s.homepage = 'https://zap-proto.io'

  s.authors = ['ZAP Protocol']
  s.email = ['dev@zap-proto.io']

  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rake-compiler', '~> 1.2'

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'interactive_editor'

  s.extensions = ['ext/zap/extconf.rb']
  s.require_paths = ['lib']

  s.files = `git ls-files`.split("\n")
end
