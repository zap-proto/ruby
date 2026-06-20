require 'mkmf'
require File.expand_path("../cxx_compiler", __FILE__)

compiler = CXXCompiler.new({'CXX' => CONFIG['CXX']}.merge(ENV.to_hash))
unless compiler.has_cxx11_compiler_support?
  abort "*** A compiler with support for C++11 language features is required."
end
unless compiler.has_cxx11_library_support?
  abort "*** A C++ library with support for C++11 features is required."
end

CONFIG['CXX']      = ENV['CXX'] || CONFIG['CXX']
CONFIG['CXXFLAGS'] = [(ENV['CXXFLAGS'] || CONFIG['CXXFLAGS']),
                      compiler.std_flag,
                      compiler.stdlib_flag].join(' ')

if enable_config('debug')
  CONFIG['CFLAGS'] += " -O0 -ggdb3"
else
  $CPPFLAGS += " -DNDEBUG"
end

# ZAP C++ runtime. Until standalone libzap ships, the binding builds against
# the upstream-compatible serialization runtime (external dependency, not ZAP
# brand): the capnp/kj headers and -lcapnpc/-lcapnp/-lkj. Retargets to <zap/...>
# / -lzap when the ZAP runtime is published.
#
# Header/lib discovery (in order): an explicit --with-capnp-dir, then pkg-config
# (covers Homebrew/non-default prefixes), then the linker's default search path.
dir_config('capnp')
pkg_config('capnp')

$LDFLAGS += " -lcapnpc"
$LDFLAGS += " -lcapnp"
$LDFLAGS += " -lkj"

create_makefile('zap/zap')
