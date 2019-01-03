class mcollective {
tag 'mcollective'

$mclibpath = $::osfamily ? {
	"Debian" => "/usr/share/mcollective/plugins/mcollective",
	"RedHat" => "/usr/libexec/mcollective/mcollective",
}

case $::operatingsystemmajrelease {
        '6': {
        $installation_required = 'true'
        $configuration_required = 'true'
           }
        '7': {
        $installation_required = 'true'
        $configuration_required = 'true'
           }
        'default': {
        $installation_required = "false"
        $configuration_required = "false"
        warning("Module ${module_name} is not supported on ${::operatingsystem} for ${::operatingsystemmajrelease}")
           }
}

notify { "mcollective libpath : $mclibpath" : }

define mco($installation_required = $installation_required) {

if ($installation_required == 'true') {
package {"$title" :
ensure => installed,
}

}
}

define shellcmd-agent($mclib = $mclibpath) {

notify { "mcollective libpath for $title : $mclib" : }

file {"$mclib/agent/$title" :
ensure => present,
source => "puppet:///modules/mcollective/mcollective-shellcmd-agent/agent/$title",
mode => 0644,
owner => root,
group => root,
}
}

define files() {
file { "/var/log/$title" :
ensure => present,
}
}

define shellcmd-application() {
file {"$mclib/application/$title" :
ensure => present,
source => "puppet:///modules/mcollective/mcollective-shellcmd-agent/application/$title",
mode => 0644,
owner => root,
group => root,
}
}

define rpminstall() {
file {"/tmp/$title":
ensure => present,
source => "puppet:///modules/mcollective/$title",
mode => 0644,
}

package {"$title":
provider => gem,
ensure => installed,
source => "/tmp/$title",
require => File["/tmp/$title"],
}

}

$packs = mcopack()

$packages = split($packs," ")

notify{"Mcollective Packages Needs To Be Installed are : $packages": }

$names = [ 'control_f0003', 'control_f0002' ]

files { $names: }

mco { $packages:
installation_required => $installation_required
}

$agent = [ 'shellcmd.ddl', 'shellcmd.rb' ]

$application = [ 'shellcmd.rb' ]

$gem = [ 'open4-1.3.0.gem' ]

if $configuration_required == 'true' {

shellcmd-agent { $agent:
mclib => $mclibpath,
require => File["/etc/mcollective/server.cfg"],
}

notify{'notification':
message => "MAKING CHANGES TO MCOLLECTIVE SERVER.CFG..",
}

rpminstall { $gem:
notify => Service[mcollective],
}

file {"/etc/mcollective/server.cfg":
notify => Notify['notification'],
content => template('mcollective/mcollective_server.cfg.erb'),
}

service{"mcollective":
ensure => running,
enable => true,
subscribe => File["/etc/mcollective/server.cfg"],
}
}

}
