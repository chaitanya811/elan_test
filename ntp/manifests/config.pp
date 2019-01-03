#
class ntp::config inherits ntp {

  if $keys_enable {
    $directory = ntp_dirname($keys_file)
    file { $directory:
      ensure  => directory,
      owner   => 0,
      group   => 0,
      mode    => '0755',
    }
  }

  file { $config:
    ensure  => file,
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($config_template),
  }

  exec {'zoneinfo':
  command => "/bin/ln -sf /usr/share/zoneinfo/CST6CDT /etc/localtime",
  unless => "/usr/bin/test -h /etc/localtime",
}

}
