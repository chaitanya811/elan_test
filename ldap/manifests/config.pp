class ldap::config ( 
$ldif = [ "chrootpw.ldif", "chdomain.ldif", "mod_syncprov.ldif", "syncprov.ldif" ],
$ldif_mgr = [ "basedomain.ldif" ],
$ldapdirs = [ "/root/ldap-scripts", "/root/ldap-users"  ]
) {

$ldapdomain = hiera_array('ldap::domain')
$domain = join($ldapdomain,",")
$password = hiera('ldap::admin')
$crypt = hiera('ldap::crypt')

define ldapadd () {

exec { "ldap/$title":
path => [ "/usr/bin", "/usr/sbin", "/bin" ],
command => "ldapadd -c -Y EXTERNAL -H ldapi:/// -f /root/ldap-scripts/$title",
returns => [ "0", "80" ],
}

}

define ldapadd_mgr ( 
$password = $password,
$domain = $domain, 
) 
{

exec {"ldapadd_mgr/$title":
path => [ "/usr/bin", "/usr/sbin", "/bin" ],
command => "ldapadd -c -x -D cn=Manager,$domain -w $password -f /root/ldap-scripts/$title ",
logoutput => true,
returns => [ "0", "68", "53" ],
}

}

define fcopy ()
{

file {"/root/ldap-scripts/$title":
ensure => present,
mode => "755",
owner => root,
group => root,
content => template("ldap/${title}.erb"),
}

}

file {"/var/lib/ldap/DB_CONFIG":
ensure => present,
mode => "644",
owner => ldap,
group =>ldap,
content => template("ldap/db_config.erb"),
alias => "DB_CONFIG",
}

fcopy { $ldif : 
before => File[ "basedomain.ldif" ],
}

file {"/root/ldap-scripts/passwd.exp":
ensure => present,
mode => "755",
owner => root,
group => root,
source => "puppet:///modules/ldap/passwd.exp",
alias => "passwd.exp",
require => File[ $ldapdirs ],
}

file {"/root/ldap-scripts/basedomain.ldif":
ensure => present,
mode => "755",
owner => root,
group => root,
content => template("ldap/basedomain.ldif.erb"),
alias => "basedomain.ldif",
}

ldapadd { $ldif :
require => File[ "basedomain.ldif" ],
}

ldapadd_mgr { $ldif_mgr :
password => "${password}",
domain => "${domain}",
require => File[ "$ldif_mgr" ] 
}

}
