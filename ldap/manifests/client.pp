class ldap::client {
tag 'ldap-client'
require ldap::vrespkg

realize(Ldap::Vrespkg::Clientp['client'])

exec { "parentdirs":
  path => [ "/usr/sbin", "/bin", "/sbin", "/usr/bin" ],
  command => "mkdir -p /etc/openldap/cacerts",
}

File <<| tag == "ldap-cacert" |>> {
require => Exec["parentdirs"],
}

File <<| tag == "pam-ldap" |>> {
notify => Service["nslcd"],
}

exec {"auth":
path => [ "/usr/sbin", "/bin", "/sbin", "/usr/bin" ],
command => "authconfig --enablemkhomedir --enableforcelegacy --enableldap --enableldapauth --enableldaptls --enableldapstarttls --update",
}

File <<| tag == 'ldapserver-primary' |>> {
notify => Service["nslcd"],
}

File <<| tag == 'ldap-ssh' |>> {
notify => Service [ "nslcd" ],
require => Exec["parentdirs"],
}

service {"sshd": ensure => running, }

case $::operatingsystemmajrelease {
  '7': {

augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
  changes => [
    "set AuthorizedKeysCommand /usr/libexec/openssh/ssh-ldap-wrapper",
    "set AuthorizedKeysCommandUser root"
  ],
  notify => Service [ "sshd" ],
  }

 }

  default: {

augeas { "sshd_config":
  context => "/files/etc/ssh/sshd_config",
  changes => [
    "set AuthorizedKeysCommand /usr/libexec/openssh/ssh-ldap-wrapper",
    "set AuthorizedKeysCommandRunAs root"
  ],
  notify => Service [ "sshd" ],
  }

 }

}

file { "/usr/libexec/openssh/ssh-ldap-wrapper":
  ensure => present,
  mode => "755",
  source => "puppet:///modules/ldap/ssh-ldap-wrapper",
}

service {"nslcd": ensure => running, }

}
