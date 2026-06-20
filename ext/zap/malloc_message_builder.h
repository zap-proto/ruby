#ifndef MALLOC_MESSAGE_BUILDER_H
#define MALLOC_MESSAGE_BUILDER_H

#include "ruby_zap.h"

namespace ruby_zap {
  class MallocMessageBuilder {
  public:
    using WrappedType = capnp::MallocMessageBuilder;
    static void Init();
    static VALUE alloc(VALUE klass);
    static VALUE initialize(VALUE klass);
    static void free(WrappedType* p);
    static WrappedType* unwrap(VALUE self);
    static VALUE init_root(VALUE name, VALUE schema);

    static VALUE Class;
  };
}

#endif
