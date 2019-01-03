class openldap::pam () {

file { "/etc/pam_debug":
  ensure => present,
  owner => root,
  group => root,
  mode => 0644,
}

file { "/etc/rsyslog.d/debug.conf":
  content => "*.debug /var/log/debug.log\n",
  owner => root,
  group => root,
  mode => 0644,
}

}
