class networking {
include networking::params
$content = hiera('networking::content')
notify {"Default DNS config file for $::hostname : $networking::params::default_file":}
notify {"DNS content file $::hostname : $content":}
          file {"$networking::params::default_file" :
          ensure => present,
          group => "root",
          content => template($content),
          owner => "root",
          mode => "0644",
}
}

include networking::reload
