# frozen_string_literal: true

#
# has_interface_with
#
module Puppet::Parser::Functions
  newfunction(:has_interface_with, type: :rvalue, doc: <<-DOC
    @summary
      Returns boolean based on kind and value.

    @return
      boolean values `true` or `false`

    Valid kinds are `macaddress`, `netmask`, `ipaddress` and `network`.

    @example **Usage**
      has_interface_with("macaddress", "x:x:x:x:x:x") # Returns `false`
      has_interface_with("ipaddress", "127.0.0.1") # Returns `true`

    @example If no "kind" is given, then the presence of the interface is checked:
      has_interface_with("lo") # Returns `true`
  DOC
  ) do |args|
    raise(Puppet::ParseError, "has_interface_with(): Wrong number of arguments given (#{args.size} for 1 or 2)") if args.empty? || args.size > 2

    interfaces = lookupvar('interfaces')

    # If we do not have any interfaces, then there are no requested attributes
    return false if interfaces == :undefined || interfaces.nil?

    interfaces = interfaces.split(',')

    return interfaces.member?(args[0]) if args.size == 1

    kind, value = args

    # Bug with 3.7.1 - 3.7.3  when using future parser throws :undefined_variable
    # https://tickets.puppetlabs.com/browse/PUP-3597
    factval = nil
    begin
      catch :undefined_variable do
        factval = lookupvar(kind)
      end
    rescue Puppet::ParseError
    end
    return true if factval == value

    result = false
    interfaces.each do |iface|
      iface.downcase!
      factval = nil
      begin
        # Bug with 3.7.1 - 3.7.3 when using future parser throws :undefined_variable
        # https://tickets.puppetlabs.com/browse/PUP-3597
        catch :undefined_variable do
          factval = lookupvar("#{kind}_#{iface}")
        end
      rescue Puppet::ParseError
      end
      if value == factval
        result = true
        break
      end
    end

    result
  end
end
