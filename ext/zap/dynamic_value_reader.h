#ifndef DYNAMIC_VALUE_READER_H
#define DYNAMIC_VALUE_READER_H

#include "ruby_zap.h"

namespace ruby_zap {
  class DynamicValueReader {
  public:
    static VALUE to_ruby(capnp::DynamicValue::Reader value, VALUE parent);
  };
}

#endif /* DYNAMIC_VALUE_READER_H */
