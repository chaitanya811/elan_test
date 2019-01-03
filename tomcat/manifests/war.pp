class tomcat::war ($warfile,$wardir = '/usr/tomcat/webapps'){
tag 'tomcat'

define warloop ($wardir) {

notify {"War file being deployed is $title to $wardir/${title}.war on $::fqdn": }

exec {"download_war_$title":
  path => [ "/usr/sbin", "/sbin", "/usr/bin", "/bin" ],
  cwd => "/root",
  command => "/usr/bin/wget --timestamping http://edallinp04.elan.elantecs.com/wars/${title}.war &> /tmp/file.$$;grep retrieving /tmp/file.$$ || rm -rf $wardir/${title}.*;rm -rf /tmp/file.$$",
  returns => ["0", "1"],
  }

file {"$wardir/${title}.war":
  ensure   => present,
  backup   => false,
  mode     => '0644',
  owner    => 'root',
  group    => 'root',
  force    => 'true',
  source   => "/root/${title}.war",
  notify   => Service['tomcat'],
  require  => Exec[ "download_war_$title" ],
  }
}

$wararray = split($warfile,",")

warloop {$wararray :
  wardir => $wardir,
}

}
