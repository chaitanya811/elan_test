class networking::params {

case $::osfamily {
'RedHat': {
$default_file = '/etc/resolv.conf'
}
'Debian': {
$default_file = '/etc/resolvconf/resolv.conf.d/head'
}
default: {
          fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
        }
}
}
