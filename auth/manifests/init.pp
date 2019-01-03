class auth {

define conf_files () {

notify{"COPYING $title FILE..":}

file {"/etc/puppet/$title":
source => "puppet:///modules/auth/$title",
}
}

$conf = [ 'auth.conf', 'namespaceauth.conf' ]

conf_files{ $conf: }

file_line { "listen":
path => "/etc/puppet/puppet.conf",
line => 'listen = true',
}

}
