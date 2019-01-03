class users {
tag 'users'

$elanadmin_private_key = hiera(elanadmin::private::key)

group {"elanadmin":
ensure => present,
gid => 510,
}

group { 'elanaws':
ensure => 'present',
gid    => '10010',
}

user { "elanadmin":
ensure => present,
comment => "ELANADMIN SHARED ACCOUNT",
uid => 1234,
gid => 510,
password => '$1$A8DwgX9t$xuwbDGV11wGAmEBssGz4C1',
shell => "/bin/bash",
home => "/home/elanadmin",
groups => ["elanadmin","adm","users"],
managehome => true,
}

file {"/home/elanadmin/.ssh":
ensure => directory,
mode => "0700",
owner => "elanadmin",
group => "elanadmin",
before => File[ "/home/elanadmin/.ssh/id_rsa" ]
}

file {"/home/elanansible/.ssh":
ensure => directory,
mode => "0700",
owner => "elanansible",
group => "elanansible",
before => File[ "/home/elanansible/.ssh/id_rsa" ]
}

user {"elanansible":
  ensure           => 'present',
  comment          => 'ansible automation account',
  gid              => '12356',
  groups           => $sudo_group,
  home             => '/home/elanansible',
  password         => '$1$bkXnTYW/$pQzP0nuj/IriNAM5yl6oR.',
  shell            => '/bin/bash',
  uid              => '12356',
  managehome       => true,
}

group {"elanansible":
  ensure           => 'present',
  gid              => '12356',
}

file {"/home/elanadmin/.ssh/id_rsa":
ensure => present,
mode => "0400",
owner => "elanadmin",
group => "elanadmin",
content => template('users/id_rsa.erb'),
require => User["elanadmin"]
}

file {"/home/elanansible/.ssh/id_rsa":
ensure => present,
mode => "0400",
owner => "elanansible",
group => "elanansible",
content => template('users/id_rsa.erb'),
require => User["elanansible"]
}

}
