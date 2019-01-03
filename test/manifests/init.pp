class test ($value = false, $value1 = "/tmp/$value") inherits test::vres {


notify {"Returned Value is $value": }

notify {"VALUE1 is $value1": }

exec {"echo tests1 >> /tmp/motd":
       path => ['/sbin' , '/bin', '/usr/sbin', '/usr/bin', '/usr/local/bin'],
       onlyif => 'test -f /tmp/motd',
       logoutput => $value,
      }

#Virtual Resource and Realize

realize(User['deploy'],Group['www-data'])

$temp = $::hostname ? {
  edallinp01 => $mco,
}

#$packages = split($::mcopackages,"\n")

#notify {"MCO PACKAGES ON $::hostname ARE $packages" :}

$a = "1,2,3"
$b = "4,5,6"
$c = $a + $b

notify {"Value of c is $c": }

}


