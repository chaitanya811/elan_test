class ldap::sshkeys {

$sshldif = [ "sshkeys.ldif" ]

ldap::config::ldapadd { $sshldif :
require => File[ "sshkeys" ],
}

file {"/root/ldap-scripts/sshkeys.ldif":
ensure => present,
mode => 755,
owner => root,
group => root,
content => template("ldap/sshkeys.ldif.erb"),
alias => "sshkeys",
}

}
