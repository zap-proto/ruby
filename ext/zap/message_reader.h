#ifndef MESSAGE_READER_H
#define MESSAGE_READER_H

#include "ruby_zap.h"

namespace ruby_zap {
  class MessageReader {
  public:
    using WrappedType = capnp::MessageReader;
    static void Init();
    static WrappedType* unwrap(VALUE self);

    static VALUE Class;
  };
}

#endif /* MESSAGE_READER_H */
