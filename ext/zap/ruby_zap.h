#ifndef RUBY_ZAP_H
#define RUBY_ZAP_H

#include <iostream>
#include <vector>

// ZAP C++ runtime. Until standalone libzap headers/libs are published, this
// binding links the upstream-compatible serialization runtime: the kj/ and
// capnp/ headers below and -lkj/-lcapnp/-lcapnpc (see extconf.rb) are the
// external runtime dependency, not ZAP brand identity. They retarget to
// <zap/...> / -lzap when the ZAP runtime ships.
#include <kj/common.h>
#include <kj/array.h>

#include <capnp/any.h>
#include <capnp/serialize.h>
#include <capnp/serialize-packed.h>
#include <capnp/message.h>
#include <capnp/schema-parser.h>
#include <capnp/schema.h>
#include <capnp/message.h>
#include <capnp/dynamic.h>

#include <ruby.h>
#ifdef __
#undef __
#endif
#ifdef HAVE_RUBY_ENCODING_H
#include "ruby/encoding.h"
#endif

#if defined(RUBY_METHOD_FUNC)
# undef RUBY_METHOD_FUNC
# if RUBY_VERSION_CODE <= 166
    extern "C" typedef VALUE (*RUBY_METHOD_FUNC)();
# else
    extern "C" typedef VALUE (*RUBY_METHOD_FUNC)(ANYARGS);
# endif
#endif

namespace ruby_zap {
}

#endif /* RUBY_ZAP_H */
