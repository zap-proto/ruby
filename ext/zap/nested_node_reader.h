#ifndef NESTED_NODE_READER_H
#define NESTED_NODE_READER_H

#include "ruby_zap.h"

namespace ruby_zap {
  class NestedNodeReader {
  public:
    using WrappedType = capnp::schema::Node::NestedNode::Reader;
    static void Init();
    static VALUE alloc(VALUE klass);
    static VALUE create(WrappedType reader);
    static void free(WrappedType* p);
    static WrappedType* unwrap(VALUE self);
    static VALUE name(VALUE self);

    static VALUE Class;
  };
}

#endif /* NESTED_NODE_READER_H */
