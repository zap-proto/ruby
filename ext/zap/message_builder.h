#ifndef MESSAGE_BUILDER_H
#define MESSAGE_BUILDER_H

#include "ruby_zap.h"

namespace ruby_zap {
  class MessageBuilder {
  public:
    using WrappedType = capnp::MessageBuilder;
    static void Init();
    static WrappedType* unwrap(VALUE self);

    static VALUE Class;
  };
}

#endif /* MESSAGE_BUILDER_H */
