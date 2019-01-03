# == Class: ibm-iemclient
#
# Full description of class iemclient here.
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
#  class { 'ibm-iemclient':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class ibm-iemclient {
tag 'iem-client'

if $::dmztype == "nonDMZ" {
	case $::location {
		'20H': { $loc = oor }
                default: { $loc = trusted }
        } 
}
elsif $::dmztype == "DMZ" {
	$loc = dmz
}
else {
	notify{ "This module is not supported for Unknown dmztype : ${::dmztype}." :} 
}

case $loc {
	'OOR': { $config = "besclient.config.oor" }
        'dmz': { $config = "besclient.config.dmz" }
        default: { $config = "besclient.config" }
}

case $::osfamily {

"SLES": {

$pkg_provider = "rpm"

	}
}

case $::osfamily {

"SLES": {

notify {"dmztype is $::dmztype and IEM config file is $config" :}

Exec{ path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

$download_url = hiera(iem::client::url)
$tar = hiera(iem::client::tar)
$check_file = "/var/tmp/iem/iem-client-installed"

file { "/var/tmp/iem":
	ensure => directory,
	mode => "755",
}

exec {"download_iem_client":
	command => "wget -N --mirror ${download_url}/${tar} &> ${check_file}",
	cwd => "/var/tmp/iem",
        creates => "${check_file}",
	require => File["/var/tmp/iem"],
        notify => Exec["untar_iem_client"],
}


exec {"untar_iem_client":
	command => "tar -xvf ${tar}",
        cwd => "/var/tmp/iem",
        refreshonly => true,
        notify => Package[BESAgent],
}

package {"BESAgent":
	provider => "${pkg_provider}",
	ensure => latest,
	source => "$::iempackage"
}

file {["/etc/opt", "/etc/opt/BESClient", "/var/opt/BESClient"]:
	ensure => directory,
	mode => "755",
        require => Package["BESAgent"],
        alias => basedirs,
}

file {"/var/opt/BESClient/besclient.config":
	ensure => present,
	source => "/var/tmp/iem/besclient.config.${loc}",
        require => File["basedirs"],
}

file {"/etc/opt/BESClient/actionsite.afxm":
        ensure => present,
	mode => "600",
        source => "/var/tmp/iem/actionsite.afxm",
        require => File["basedirs"],
}

service {"besclient":
	ensure => running,
        subscribe => File["/etc/opt/BESClient/actionsite.afxm", "/var/opt/BESClient/besclient.config"]
}

	}
default: {

	notify { "This Module is not supported for $::osfamily" :}
}

	}

}
