define python_pip::pip2_module_install () {

exec {"pip2-$name" :
  path      => [ '/usr/sbin', '/bin', '/sbin', '/usr/bin', '/usr/local/bin' ],
  provider  => shell,
  command   => "pip2 install ${name}",
  unless    => "pip2 list | grep -w ${name}",
  logoutput => true,
  loglevel  => info,
  }

}
