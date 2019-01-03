class php-git
{
exec {"php-dir":
    path => "/usr/bin:/usr/sbin:/bin:/sbin",
    command => 'mkdir -p /etc/puppet/modules/php-git/files',
    unless => 'test -d /etc/puppet/modules/php-git/files',
    before => Exec['get-php'],
}

exec {"get-php":
     path => "/usr/bin:/usr/sbin:/bin:/sbin",
     command => "wget https://github.com/symfony/symfony/blob/8d69022c04e7e5f544850e37da46fd8e2f3067c9/src/Symfony/Component/Process/PhpExecutableFinder.php -O /etc/puppet/modules/php-git/files/PhpExecutableFinder.php",
     unless => 'test -f /etc/puppet/modules/php-git/files/PhpExecutableFinder.php',
     }
}
