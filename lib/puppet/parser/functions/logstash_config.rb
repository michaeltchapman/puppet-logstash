# logstash configuration format production function
def logstash_config(obj, depth=0)
  d = depth
  white = '  '
  case obj
    when String, Fixnum, Float, TrueClass, FalseClass, NilClass
      return " => #{obj.to_s}\n"
    when NilClass
      return " { }\n"
    when Array
      ret = []
      obj.each do |a|
        ret.push(logstash_config(a, d))
      end
      return ret.join("")
    when Hash
      ret = []
      obj.keys.sort.each do |k|
        value = obj[k]
        case value
          when String, Fixnum, Float, TrueClass, FalseClass
            ret.push("#{white * d}#{k.to_s} => #{value.to_s}\n")
          when NilClass
            ret.push("#{white * d}#{k.to_s} { }\n")
          else
            ret.push("#{white * d}#{k.to_s} {\n#{logstash_config(value, d+1)}#{white * d}}\n")
        end
      end
      return ret.join("")
    else
      raise Exception("Invalid object type <%s> in logstash config parser" % obj.class.to_s)
  end
end

module Puppet::Parser::Functions
  newfunction(:logstash_config, :type => :rvalue, :doc => <<-EOS
This function takes a hash and creates a formatted logstash config DSL string

*Examples:*

input:
  lumberjack:
    - port: 5000
    - type: logs

returns:

 input {
   lumberjack {
     port => 5000
   }
 }
    EOS

  ) do |arguments|
    
    if arguments.size != 1
      raise(Puppet::ParseError, "logstash_config: takes only a single hash argument, you" +
      " gave #{arguments.size}")
    end

    conf = arguments[0]
    logstash_config(conf)
  end
end

# vim: set ts=2 sw=2 et :
