# == Class: motd
#
# Applies Message Of the Day to Linux Servers i.e to /etc/motd
# Create External Executables Facts Directory /etc/facter/facts.d linkd to /var/lib/puppet/facts.d 
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'motd':
#    ensure => present,
#  }
#
# === Authors
#
# Author Name <rajesh.moturi@elantecs.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#

class motd ($ensure = present)
{
tag 'motd'

Exec { path => ["/usr/bin", "/usr/sbin", "/sbin", "/bin" ] }

notify {"The Value of ENSURE is ${ensure}": }

$sudo_group = $::osfamily ? {
     "Debian"   => ['sudo'],
     default => ['wheel'],
}


file {"/etc/issue":
  ensure => $ensure,
  mode => "0444",
  content => template('motd/issue.erb'),
  owner => "root",
  group => "root",
}

file {"/etc/motd":
  ensure => $ensure,
  mode => "0444",
  content => template('motd/motd.erb'),
  owner => "root",
  group => "root",
}

file {"/etc/facter": ensure => directory, recurse => true, }

file {"/etc/facter/facts.d":
  ensure => link,
  replace => 'no',
  target => "/var/lib/puppet/facts.d",
  require => File["/etc/facter"],
}

package {"git":
  ensure => installed,
}

package {"ca-certificates":
  ensure => installed,
}

file {"edallinp01_ca":
  ensure => present,
  name => $osfamily ? { 
     RedHat => '/etc/pki/ca-trust/source/anchors/edallinp01_ca.pem', 
     default => '/usr/local/share/ca-certificates/edallinp01_ca.crt', 
  },
  mode => "644",
  owner => root,
  group => root,
  source => "puppet:///modules/motd/edallinp01_ca.pem",
  notify => Exec["update_ca"],
  require => Package["ca-certificates"],
}

exec {"update_ca":
  command => $osfamily ? {
     RedHat => "update-ca-trust force-enable && update-ca-trust extract",
     default => "update-ca-certificates",
  },
  logoutput => true,
}

file { "/var/tmp/add_cacert_python.sh":
  ensure => present,
  mode => "755",
  owner => root,
  group => root,
  source => "puppet:///modules/motd/add_cacert_python.sh",
  require => Exec["update_ca"],
}

exec {"add_cacert_python":
  command => "bash /var/tmp/add_cacert_python.sh",
  logoutput => true,
  require => File["/var/tmp/add_cacert_python.sh", "edallinp01_ca"]
}

file {"check_cron":
  ensure => present,
  path => '/etc/cron.d/nexusbackups3',
  owner => 'root',
  group => 'root',
  mode => '0644',
  content => "14 19 * * * root /home/awsadmin/aws/praveen/nexusbackups3.py &> /data/nexusbackup/nexusbackup_log_$(date \"+\\%Y-\\%m-\\%d-\\%H-\\%M-\\%S\")\n",
}

package {"postfix":
  ensure => installed,
}

file {"/etc/postfix/main.cf":
  ensure => present,
  mode => "644",
  owner => root,
  group => root,
  content => template('motd/postfix.erb'),
  require => Package["postfix"],
  notify  => Service["postfix"],
}

service {"postfix":
  ensure => running
}

}
