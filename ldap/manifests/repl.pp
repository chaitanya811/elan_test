class ldap::repl () {
tag 'ldap-repl'

$syncrepl = [ "syncrepl.ldif" ]

class { "ldap::server" :
  ldapdirs => [ "/root/ldap-scripts" ],
}

File <<| tag == 'ldap-provider' |>> {
notify => Service [ "slapd" ],
}

ldap::config::ldapadd {$syncrepl : }


class { "ldap::config" :
  ldif => [ "chrootpw.ldif", "chdomain.ldif" ],
  ldapdirs => [ "/root/ldap-scripts" ],
}

File <<| tag == 'ldap-provider' |>> {
notify => Service [ "slapd" ],
}

include ldap::sshkeys
include ldap::client

Class['ldap::server'] -> Class['ldap::config'] -> Class['ldap::sshkeys'] -> Class['ldap::client']

}
