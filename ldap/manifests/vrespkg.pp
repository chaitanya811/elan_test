class ldap::vrespkg () {

@package { [ "openldap-servers", "openldap-clients", "expect", "openssh-ldap", "nss-pam-ldapd" ] : 
ensure => installed,
loglevel => debug,
}

define serverp {
  realize(Package[ "openldap-servers", "openldap-clients", "expect" ])
}

define clientp {
  realize(Package[ "openldap-clients", "openssh-ldap", "nss-pam-ldapd" ])
}


@serverp {'server' : }
@clientp {'client' : }

}
