class test::vres {

@user {deploy:
  ensure => present,
  uid => 2004,
  comment => "Deployment User",
  gid => "www-data",
  tag => [deploy,web],
}

@group {www-data:
  ensure => present,
}

}
