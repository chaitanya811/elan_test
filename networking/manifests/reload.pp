class networking::reload {
include networking::params

case $::osfamily {
'Debian': {
exec { '/sbin/resolvconf -u':
subscribe => File["$networking::params::default_file"],
refreshonly => true,
}
}
}
}
