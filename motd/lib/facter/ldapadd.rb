require 'facter'

ldapadd = Facter::Util::Resolution.exec('ls /root/ldap-users/add 2>/dev/null | sed "s/.ldif//g" | tr "\n" " " ')

Facter.add('ldapadd') do
  setcode do
    ldapadd
  end
end
