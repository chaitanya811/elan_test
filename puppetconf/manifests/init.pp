class puppetconf {

$puppet_file = hiera('puppet::file')

notify {"Puppet template file for $::hostname : $puppet_file" :}

file {"/etc/puppet/puppet.conf" :
backup => true,
ensure => present,
owner => puppet,
group => puppet,
content => template($puppet_file),
mode => "0644",
alias => "conf",
}

file {"/etc/puppet/auth.conf" :
backup => true,
ensure => present,
source => "puppet:///modules/puppetconf/auth.conf",
alias => "auth",
}

service {"puppet":
ensure => running,
enable => true,
subscribe => File[ "conf", "auth" ],
}

}
