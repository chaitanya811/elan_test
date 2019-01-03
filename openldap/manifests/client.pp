class openldap::client () {
tag 'ldapclient'

Package { ensure => installed, }

package {"openldap-clients": } 
package {"nss-pam-ldapd": }

$ldapserver = query_nodes('Class[Openldap]')
$basedn = hiera('openldap::basedn')

notify{"LDAP SERVER : $ldapserver": }

file { [ '/etc/openldap/cacerts', '/etc/openldap/cacerts/client' ] :
  ensure => "directory",
}

file { "/etc/openldap/cacerts/client/cacert.pem":
  ensure => present,
  source => "puppet:///modules/openldap/cacert.pem",
  owner => root,
  group => root,
  mode => 0600,
}

file{"/etc/openldap/ldap.conf":
  ensure => present,
  owner => root,
  group => root,
  mode => 644,
  content => template('openldap/ldap.conf.erb')
}

}
