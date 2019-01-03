class nsupdate {

define dnssec () {

file {"/usr/bin/$title":
ensure => present,
owner => root,
group => root,
mode => 0600,
source => "puppet:///modules/nsupdate/$title",
}
}

$files = [ "Kelan.elantecs.com.+157+62060.key", "Kelan.elantecs.com.+157+62060.private" ]
dnssec {$files : }

file {"/usr/bin/create-dns-records":
ensure => present,
owner => root,
group => root,
mode => 0755,
source => "puppet:///modules/nsupdate/create-dns-records",
}

file {"/usr/bin/macgen":
ensure => present,
owner => root,
group => root,
mode => 0755,
source => "puppet:///modules/nsupdate/macgen",
}


}
