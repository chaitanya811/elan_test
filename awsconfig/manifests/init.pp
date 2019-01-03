class awsconfig {
tag 'awsconfig'

$aws_access_key = hiera(aws::access::key, 'AKIAJGTXDBWWCDDYDUXQ')
$aws_secret_key = hiera(aws::secret::key, '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')

Exec { path => ['/usr/bin', '/usr/sbin', '/bin', '/sbin', '/usr/local/bin' ] }

package { ["python", "curl"]:
ensure => installed,
}

exec { "get-pip":
cwd => "/root",
command => "curl -O https://bootstrap.pypa.io/get-pip.py",
creates => "/root/get-pip.py",
require => Package["python", "curl"],
}

#exec { "pip":
#cwd => "/root",
#command => "python get-pip.py",
#creates => "/usr/bin/pip",
#require => Exec["get-pip"],
#}

package { "python-pip":
ensure => installed,
require => Exec["get-pip"],
}

user { "awsadmin":
ensure => present,
uid => 10010,
gid => 10010,
home => "/home/awsadmin",
comment => "ELAN AWS ACCOUNT",
managehome => true,
password => hiera('awsadmin::elanaws', '$1$FnpYsoa1$vPn.wVELsZ5bIv/d.TjQR/'),
password_max_age => "99999",
password_min_age => "0",
shell => "/bin/bash",
}

exec { "awscli":
cwd => "/root",
command => "pip install awscli || pip install awscli --ignore-installed six",
creates => "/usr/bin/aws",
require => Package["python-pip"],
}

file { "awsdir":
ensure => directory,
path => "/home/awsadmin/.aws",
require => User["awsadmin"],
}

file { "creds":
ensure => present,
path => "/home/awsadmin/.aws/credentials",
content => template('awsconfig/credentials.erb'),
require => [ Exec["awscli"], File["awsdir"] ],
}

file { "config":
ensure => present,
path => "/home/awsadmin/.aws/config",
content => template('awsconfig/config.erb'),
require => File["creds"],
}

}
