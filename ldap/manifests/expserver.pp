class ldap::expserver {

$ldapdomain = hiera_array('ldap::domain')
$domain = join($ldapdomain,",")
$password = hiera('ldap::admin')

$ldapother = query_nodes('Class[Ldap::Repl]', 'ipaddress')
$ldapfqdn = query_nodes('Class[Ldap::Repl]')
$ldapsec = $ldapother[0]['ipaddress']

@@file {"ldap_primary_$::fqdn":
path => "/etc/nslcd.conf",
ensure => present,
mode => "600",
content => template("ldap/nslcd.conf.erb"),
tag => "ldapserver-primary",
}

@@file {"ldap_cacert_$::fqdn":
path => "/etc/openldap/cacerts/cacert.pem",
ensure => present,
mode => "644",
source => "puppet:///modules/ldap/cacert.pem",
tag => "ldap-cacert",
}

@@file {"ldap_sshconf_$::fqdn":
path => "/etc/openldap/ldap-ssh.conf",
ensure => present,
mode => "600",
content => template("ldap/ldap-ssh.conf.erb"),
tag => "ldap-ssh",
}

@@file {"ldap_provider_$::fqdn":
path => "/root/ldap-scripts/syncrepl.ldif",
ensure => present,
mode => "600",
content => template("ldap/syncrepl.ldif.erb"),
tag => "ldap-provider",
}

@@file {"pam_ldap_$::fqdn":
path => "/etc/pam_ldap.conf",
ensure => present,
mode => "644",
content => template("ldap/pam_ldap.conf.erb"),
tag => "pam-ldap",
}


}
