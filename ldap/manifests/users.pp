class ldap::users () inherits ldap::config {

Exec{path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

$gitlab_key = hiera('gitlab::private')
$domain = $::ldap::config::domain

notify {"LDAP DOMAIN IS : $domain" :}

include stdlib

file {"/root/.ssh/id_ecdsa" :
  backup => true,
  mode => "600",
  content => "$gitlab_key",
  alias => "gitlab_ldap_key",
}

vcsrepo { '/root/ldap-users':
  ensure   => present,
  provider => git,
  source   => 'git@edalregp01.elan.elantecs.com:GitElan/ldap-users.git',
  revision => 'production',
  require => File[ "gitlab_ldap_key" ],
}

define users ( $domain = $domain ) {

$password = hiera(ldap::admin)

notice("Adding user : $title")
notice("LDAP input file for $title is ${title}.ldif")

notify {"ldapmod-$title":
message => "Modifying user: $title",
}

exec {"ldap_add_$title":
cwd => "/root/ldap-users/add",
command => "ldapadd -c -f ${title}.ldif -D cn=Manager,$domain -w $password -Z",
returns => [ "0", "68" ],
}

exec {"ldap_mod_$title":
cwd => "/root/ldap-users/modify",
command => "ldapmodify -c -f ${title}.ldif -D cn=Manager,$domain -w $password -Z",
onlyif => "test -f $title.ldif",
subscribe => Notify["ldapmod-$title"],
}

}

$lusers = $::ldapadd
$uarray = split($lusers," ")
notify { "LDAP USERS ARE : $lusers" : }

exec {"slapd" :
command => "service slapd restart",
}

users { $uarray: 
domain => $domain,
require => Exec[ "slapd" ]
}

}
