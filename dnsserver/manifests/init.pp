class dnsserver {

package { "bind" :
ensure => installed,
allow_virtual => false,
}

file { "/etc/named.conf" :
ensure => present,
owner => "root",
group => "named",
mode => "640",
content => template('dnsserver/named.conf.erb'),
}

file { "/etc/zones.conf" :
ensure => present,
owner => "root",
group => "named",
mode => "644",
content => template('dnsserver/zones.conf.erb'),
}

service { "named" :
ensure => running,
enable => true,
subscribe => File["/etc/named.conf", "/etc/zones.conf"],
}
}
