require 'json'

def is_i(obj)
  return obj =~ /\A[-+]?[0-9]+\z/
end

def sorted_json(obj)
  case obj
    when String
      if is_i(obj)
        return obj
      end
      return obj.to_json
    when Array
      arrayRet = []
      obj.each do |a|
        arrayRet.push(sorted_json(a))
      end
      return "[" << arrayRet.join(',') << "]";
    when Hash
      ret = []
      obj.keys.sort.each do |k|
        ret.push(k.to_json << ":" << sorted_json(obj[k]))
      end
      return "{" << ret.join(",") << "}";
    else
      raise Exception("Unable to handle object of type <%s>" % obj.class.to_s)
  end
end

module Puppet::Parser::Functions
  newfunction(:sorted_json, :type => :rvalue, :doc => <<-EOS
This function takes data, outputs making sure the hash keys are sorted

*Examples:*

    sorted_json({'key'=>'value'})

Would return: {'key':'value'}
    EOS
  ) do |arguments|
    raise(Puppet::ParseError, "sorted_json(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    json = arguments[0]
    return sorted_json(json)
  end
end
