require 'facter'

ENV['PATH']='/bin:/sbin:/usr/bin:/usr/sbin'

result = %x{runlevel | awk '{print $2}'}
result.strip!

Facter.add('runlevel') do
    setcode do
        result
    end
end
