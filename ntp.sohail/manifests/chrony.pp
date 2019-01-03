# chrony config. Basic stuff, config file, service, package
#
class ntp::chrony {
  package { 'chrony':
    ensure  =>  present;
  }

  file { '/etc/chrony.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('ntp/chrony.conf.erb'),
    require => Package['chrony'];
  }

  service { 'chronyd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/chrony.conf'];
  }
}
