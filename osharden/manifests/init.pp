class osharden{

# Setting default exec path for this module
    Exec { path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin',] }

user { "root":
	ensure => present,
        password => '$1$/azHHyIA$YLw4ctnJsS7lYW9Z4NTO7/',
        gid              => '0',
        groups           => ['root', 'bin', 'daemon', 'sys', 'adm', 'disk', 'wheel'],
        home             => '/root',
        password_max_age => '99999',
        password_min_age => '0',
        shell            => '/bin/bash',
        uid              => '0',
     }
}
