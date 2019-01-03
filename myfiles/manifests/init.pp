class myfiles {
    file { '/home/secret':
        ensure => directory,
        mode => '0755',
        owner => 'elanadmin',
        group => 'elanadmin',
    }

    file { "/home/secret/universal.admin":
        mode => "0755",
        owner => 'elanadmin',
        group => 'elanadmin',
        source => 'puppet:///modules/myfiles/universal.admin',
    }
}

