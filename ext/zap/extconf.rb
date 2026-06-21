require 'mkmf'
require File.expand_path("../cxx_compiler", __FILE__)

# macOS: pin the active SDK so the compiler/linker can find system headers.
#
# Homebrew/rbenv Rubies record neither `sysroot` nor `SDKROOT` in RbConfig, and
# mkmf's generated rules omit `-isysroot`. clang then cannot find <stdio.h> or
# <iostream>, so every probe and the real build fail ("file not found"). Ask
# `xcrun` for the active SDK and apply it to all compiles and the link. No-op
# when xcrun is absent (Linux/CI) or a sysroot is already in effect, so this
# stays macOS-only and idempotent.
def macos_sysroot_flag
  return '' unless RUBY_PLATFORM =~ /darwin/
  return '' if RbConfig::CONFIG['sysroot'].to_s != '' || ENV['SDKROOT'].to_s != ''
  sdk = `xcrun --show-sdk-path 2>/dev/null`.strip
  sdk.empty? ? '' : "-isysroot #{sdk}"
end

SYSROOT_FLAG = macos_sysroot_flag
unless SYSROOT_FLAG.empty?
  # Affects all C/C++ compiles (incl. mkmf's own probes) and the link step.
  $CPPFLAGS = "#{SYSROOT_FLAG} #{$CPPFLAGS}"
  $LDFLAGS  = "#{SYSROOT_FLAG} #{$LDFLAGS}"
end

# Probe C++11 support with the same sysroot the build will use. CXXCompiler
# shells out to $CXX directly, so it needs the flag passed in explicitly.
probe_env = {'CXX' => CONFIG['CXX']}.merge(ENV.to_hash)
probe_env['CXXFLAGS'] = [probe_env['CXXFLAGS'], SYSROOT_FLAG].compact.join(' ')
compiler = CXXCompiler.new(probe_env)
unless compiler.has_cxx11_compiler_support?
  abort "*** A compiler with support for C++11 language features is required."
end
unless compiler.has_cxx11_library_support?
  abort "*** A C++ library with support for C++11 features is required."
end

CONFIG['CXX']      = ENV['CXX'] || CONFIG['CXX']
CONFIG['CXXFLAGS'] = [(ENV['CXXFLAGS'] || CONFIG['CXXFLAGS']),
                      compiler.std_flag,
                      compiler.stdlib_flag,
                      SYSROOT_FLAG].join(' ')

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
