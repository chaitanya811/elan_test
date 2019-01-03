define python_pip::pip3_module_install () {

exec {"pip3-$name":
  path      => [ '/usr/sbin', '/bin', '/sbin', '/usr/bin', '/usr/local/bin' ],
  provider  => shell,
  command   => "pip3 install ${name}",
  unless    => "pip3 list | grep -w ${name}",
  logoutput => true,
  loglevel  => info,
  }

}
