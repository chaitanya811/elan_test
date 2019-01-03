class foreman_scap_client::params {
  $ca_file          = pick($::rh_certificate_repo_ca_file, '/var/lib/puppet/ssl/certs/ca.pem')
  $host_certificate = pick($::rh_certificate_consumer_host_cert, "/var/lib/puppet/ssl/certs/${fqdn}.pem")
  $host_private_key = pick($::rh_certificate_consumer_host_key, "/var/lib/puppet/ssl/private_keys/${fqdn}.pem")
  $server = 'edallinp04.elan.elantecs.com'
  $port = '8443'
  $policies = [ { "id" => 1, "hour" => "*", "minute" => "*", "month" => "*",
                  "monthday" => "*", "weekday" => "1", "profile_id" => '',
                  "content_path" => '/usr/share/xml/scap/ssg/content/ssg-rhel7-ds.xml',
                  "download_path" => '/compliance/policies/1/content' } ]
}
