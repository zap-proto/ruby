![ZAP][logo]

# ZAP — Ruby Edition

> **Docs:** [ZAP Ruby SDK](https://zap-proto.dev/docs/sdks) · part of the [ZAP Protocol](https://zap-proto.io)


This is the [Ruby][ruby] binding for [ZAP][zap] — an insanely fast binary data
interchange format and capability-based RPC system.

# Installing

The native extension links the ZAP C++ runtime. Until the standalone `libzap`
runtime ships, the binding builds against the upstream-compatible serialization
library (`libcapnp`); install it first, then install the gem:

```bash
gem install zap --pre
```

The native extension requires a C++ compiler with C++11 features, so use the
same C++ compiler and flags you used to build the runtime (e.g. `CXX` and
`CXXFLAGS`). On macOS:

```bash
gem install zap --pre
```

> **Runtime dependency note.** This binding currently links the upstream
> serialization runtime (`libcapnp` / `<capnp/...>`, `-lcapnp -lcapnpc -lkj`).
> Those references are the external dependency surface, not ZAP brand identity;
> they retarget to `libzap` once the ZAP C++ runtime is published. Schema files
> use the `.zap` extension.

# Example

```ruby
require 'zap'

module AddressBook extend Zap::SchemaLoader
  load_schema("addressbook.zap")
end

def write_address_book(file)
  addresses = AddressBook::AddressBook.new_message
  people = addresses.initPeople(2)

  alice = people[0]
  alice.id = 123
  alice.name = 'Alice'
  alice.email = 'alice@example.com'
  alice_phones = alice.initPhones(1)
  alice_phones[0].number = "555-1212"
  alice_phones[0].type = 'mobile'
  alice.employment.school = "MIT"

  bob = people[1]
  bob.id = 456
  bob.name = 'Bob'
  bob.email = 'bob@example.com'
  bob_phones = bob.initPhones(2)
  bob_phones[0].number = "555-4567"
  bob_phones[0].type = 'home'
  bob_phones[1].number = "555-7654"
  bob_phones[1].type = 'work'
  bob.employment.unemployed = nil

  addresses.write(file)
end

def print_address_book(file)
  addresses = AddressBook::AddressBook.read_from(file)

  addresses.people.each do |person|
    puts "#{person.name} : #{person.email}"

    person.phones.each do |phone|
      puts "#{phone.type} : #{phone.number}"
    end

    if person.employment.unemployed?
      puts "unemployed"
    if person.employment.employer?
      puts "employer: #{person.employment.employer}"
    if person.employment.school?
      puts "student at: #{person.employment.school}"
    if person.employment.selfEmployed?
      puts "self employed"
    end
  end
end

if __FILE__ == $0
  file = File.open("addressbook.bin", "wb")
  write_address_book(file)

  file = File.open("addressbook.bin", "rb")
  print_address_book(file)
end
```

# Status

What's implemented:
- Schema parsing/loading
- Message reading
  - From byte string
  - From file descriptor
- Message writing
  - To byte string
  - To file descriptor

What's to come:
- More reading/writing mechanisms:
  - Packing/unpacking
- Extensive test coverage
- Proper support for [JRuby][jruby]
- Support for RPC

[logo]: media/zap_logo_small.png "ZAP"
[ruby]: http://www.ruby-lang.org/ "Ruby"
[zap]: https://zap-proto.io "ZAP Protocol"
[jruby]: http://jruby.org/ "JRuby"
[mit-license]: http://opensource.org/licenses/MIT "MIT License"