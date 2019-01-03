class {"tomcat":
  install_from_source => false,
}
include tomcat::install
include tomcat::service

Class['tomcat'] -> Class['tomcat::install'] -> Class['tomcat::service']
