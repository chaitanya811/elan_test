class openldap::ldapdb () {

$basedn = hiera('openldap::basedn')
$maindc = hiera('openldap::maindc')
$fulldc = hiera('openldap::fulldc')

notify {"BASEDN for LDAP SERVER is : $basedn" :}

@@host { "$::fqdn":
  ip  => $::ipaddress,
  tag => "ldaphost",
}

ldapdn{'set root dn':
  dn => 'olcDatabase={2}bdb,cn=config',
  attributes => ["olcSuffix: $basedn",
                 "olcRootDN: cn=Manager,$basedn"],
  unique_attributes => ['olcSuffix', 'olcRootDN'],
  ensure => present,
}

ldapdn{'set general access':
  dn => 'olcDatabase={2}bdb,cn=config',
  attributes => ['olcAccess: {1}to * by self write by anonymous auth by dn.base="cn=Manager,$basedn" write by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" manage by * read'],
  ensure => present,
  require => Ldapdn["set root dn"],
}

ldapdn{'add database':
  dn => "dc=elan,dc=elantecs,dc=com",
  attributes => ['dc: $maindc',
                 'objectClass: top',
                 'objectClass: dcObject',
                 'objectClass: organization',
                 'o: $fulldc'],
  unique_attributes => ['dc', 'ou'],
  ensure => present,
  require => Ldapdn["set general access"],
}

ldapdn{ "ou Group":
  dn => "ou=Group,$basedn",
  attributes => ["ou: Group",
                 'objectClass: organizationalUnit'],
  unique_attributes => ['ou'],
  ensure => present,
  require => Ldapdn["add database"],
}

ldapdn{ "ou People":
  dn => "ou=People,$basedn",
  attributes => ["ou: People",
                 'objectClass: organizationalUnit'],
  unique_attributes => ['ou'],
  ensure => present,
  require => Ldapdn["add database"],
}

ldapdn{ "ou Services":
  dn => "ou=Services,$basedn",
  attributes => ["ou: Services",
                 'objectClass: organizationalUnit'],
  unique_attributes => ['ou'],
  ensure => present,
  require => Ldapdn["add database"],
}

ldapdn{"group elanadmins":
  dn => "cn=ldapadmins,ou=Group,$basedn",
  attributes => ["cn: ldapadmins",
                 'objectClass: posixGroup',
                 'gidNumber: 2016'],
  unique_attributes => ['cn', 'gidNumber'],
  ensure => present,
  require => Ldapdn["ou Group"],
}

}
