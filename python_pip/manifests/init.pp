# == Class: python_pip
#
# Full description of class python_pip here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'python_pip':
#  }
#
# === Authors
#
# Author Name <kurrapr@verizon.com>
#
# === Copyright
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class python_pip {

tag 'python_pip'

$redhat_misc_packages = hiera(python_pip::package::redhat, [ 'epel-release', 'python34', 'zlib-devel', 'bzip2', 'bzip2-devel', 'readline-devel', 'openssl-devel', 'wget' ])
$debian_misc_packages = hiera(python_pip::package::debian, [ 'python3.5', 'gcc', 'bzip2', 'wget' ])
$pip2_modules = hiera(python_pip::pip2, ['requests', 'PyYAML'])
$pip3_modules = hiera(python_pip::pip3, ['requests', 'PyYAML'])

Exec { path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', '/usr/local/bin' ] }

case $::osfamily {
  'RedHat' : {
     case $::lsbmajdistrelease {
       '7' : { $package_name = concat($redhat_misc_packages, 'python2-pip') }
       default : { $package_name = concat($redhat_misc_packages, 'python-pip') }
     }
  }
  'Debian' : { $package_name = concat($debian_misc_packages, 'python-pip') }
  default : { fail("module ${module_name} not supported on ${::operatingsystem}") }
}

package {$package_name :
  ensure   => installed,
  loglevel => info,
  before => Exec["get-pip3"],
}

exec { "get-pip3":
cwd => "/root",
command => "wget --no-check-certificate -O get-pip.py https://bootstrap.pypa.io/get-pip.py",
creates => "/usr/bin/pip3",
}

exec { "pip3":
cwd => "/root",
command => "python3 get-pip.py",
creates => "/usr/bin/pip3",
require => Exec["get-pip3"],
}

if $pip2_modules {
# Call defined type from pip2_module_install.pp
pip2_module_install { $pip2_modules :
  require => [ Package[$package_name] ]
  }
}

if $pip3_modules {
# Call defined type from pip3_module_install.pp
pip3_module_install { $pip3_modules :
  require => [ Package[$package_name], Exec["pip3"] ]
  }
}

}
