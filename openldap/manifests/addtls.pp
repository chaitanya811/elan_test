class openldap::addtls () {

$chash = hiera('openldap::chash')

file {[ "/etc/openldap/certs", "/etc/openldap/cacerts", "/etc/openldap/cacerts/server" ]:
  ensure => directory,
  mode => "755",
  owner => ldap,
  group => root,
}

file {"/etc/openldap/certs/slapd.key":
  ensure => present,
  source => "puppet:///modules/openldap/slapd.key",
  owner => ldap,
  group => root,
  mode => 0600,
}

file {"/etc/openldap/certs/slapd.crt":
  ensure => present,
  source => "puppet:///modules/openldap/slapd.crt",
  owner => ldap,
  group => root,
  mode => 0600,
}

file {"cacert_to_chash":
  path => "/etc/openldap/cacerts/server/$chash",  # remember the hash_c code!
  ensure => present,
  source => "puppet:///modules/openldap/$chash",   # the cacert.pem you generated
  owner => ldap,
  group => root,
  mode => 0600,
}

ldapdn {"add tls":
  dn => 'cn=config',
  attributes => [inline_template('olcTLSCACertificateFile: /etc/openldap/cacerts/<%=@chash%>'), # substitute!
                                 'olcTLSCertificateFile: /etc/openldap/certs/slapd.crt',
                                 'olcTLSCertificateKeyFile: /etc/openldap/certs/slapd.key'],
  unique_attributes => ['olcTLSCACertificateFile', 'olcTLSCertificateFile', 'olcTLSCertificateKeyFile'],
  ensure => present,
  require => File["cacert_to_chash"],
}

}
