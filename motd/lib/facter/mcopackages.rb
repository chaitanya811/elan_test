require 'facter'

array = []
package_data = Facter::Util::Resolution.exec('rpm -qa --qf "%{RPMTAG_NAME}\n" | grep "mcollective-.*-" | tr "\n" " "')

Facter.add('mcopackages') do
  confine :osfamily => "RedHat"
  setcode do
    package_data + "mcollective"
  end
end
