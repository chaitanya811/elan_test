class ldap::server (
$ldapdirs = [ "/root/ldap-scripts", "/root/ldap-users"  ],
) {
include ldap::vrespkg

realize(Ldap::Vrespkg::Serverp['server'])

$ldapdomain = hiera_array('ldap::domain')
$domain = join($ldapdomain,",")

service {"slapd": 
ensure => running, 
enable => true,
}

file { [ "/etc/openldap", "/etc/openldap/cacerts", "/etc/openldap/certs", "/root/LDAP_CERTS", "/root/LDAP_CERTS/private" ] :
  ensure => directory,
  owner => ldap,
  group => root,
  before => File[ "gen_tls_certs" ],
}

file { "/root/LDAP_CERTS/gen_tls_certs.sh" :
  ensure => present,
  mode => "755",
  source => "puppet:///modules/ldap/gen_tls_certs.sh",
  alias => "gen_tls_certs",
}

file { "/root/LDAP_CERTS/cacert.pem" :
  ensure => present,
  source => "puppet:///modules/ldap/cacert.pem",
  alias => "cacert",
  require => File[ "gen_tls_certs" ],
}

file { "/root/LDAP_CERTS/private/cakey.pem" :
  ensure => present,
  source => "puppet:///modules/ldap/cakey.pem",
  alias => "cakey",
  require => File [ "cacert" ],
}

exec { "slapd-cert" :
  path => [ "/usr/bin", "/usr/sbin", "/sbin", "/bin" ],
  command => "/root/LDAP_CERTS/gen_tls_certs.sh",
  creates => "/etc/openldap/certs/slapd.crt",
  require => File[ "cakey" ],
}

file { "cahash":
  path => "/etc/openldap/cacerts/$::chash",
  ensure => present,
  source => "puppet:///modules/ldap/cacert.pem",
  owner => ldap,
  group => root,
  mode => 0600,
  require => Exec[ "slapd-cert" ],
  notify => Service[ "slapd" ],
}

file {$ldapdirs :
ensure => directory,
}

service { [ "iptables", "ip6tables" ] :
enable => false,
ensure => stopped,
}

}
