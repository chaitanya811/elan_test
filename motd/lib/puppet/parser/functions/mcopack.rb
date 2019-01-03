require 'facter'
module Puppet::Parser::Functions
  newfunction(:mcopack, :type => :rvalue) do
            result = Facter['mcopackages'].value
            return result
  end
end
