class openldap () {

tag 'ldapserver'

Package { ensure => 'latest' }

package {"openldap-servers": }
package {"openldap-clients": }

service {"slapd":
ensure => running,
require => Package[ "openldap-servers", "openldap-clients" ],
}

ldapdn{"add manager password":
  dn => "olcDatabase={2}bdb,cn=config",
  attributes => ["olcRootPW: elantecs123"],
  unique_attributes => ["olcRootPW"],
  ensure => present,
  require => Service["slapd"],
}

file { "/etc/rsyslog.d/slapd.conf":
  ensure => file,
  content => "local4.debug           /var/log/slapd.log\n",
  owner => root,
  group => root,
  mode => 0644,
}

#file_line { 'Add SLAPD Options':
#  path => '/etc/sysconfig/ldap',
#  line => 'SLAPD_OPTIONS="-d 255"  # Use -1 for the highest level of debug',
#  match   => "^#SLAPD_OPTIONS.*$",
#}


include openldap::addtls
include openldap::ldapdb

Class['openldap::addtls'] -> Class['openldap::ldapdb']

}
