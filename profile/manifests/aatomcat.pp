class profile::aatomcat ()
{
class {"tomcat":
  install_from_source => false,
}

contain tomcat
contain tomcat::install
contain tomcat::service

}
