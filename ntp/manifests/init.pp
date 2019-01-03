class ntp (
  $autoupdate        = $ntp::params::autoupdate,
  $config            = $ntp::params::config,
  $config_template   = $ntp::params::config_template,
  $disable_monitor   = $ntp::params::disable_monitor,
  $driftfile         = $ntp::params::driftfile,
  $logfile           = $ntp::params::logfile,
  $iburst_enable     = $ntp::params::iburst_enable,
  $keys_enable       = $ntp::params::keys_enable,
  $keys_file         = $ntp::params::keys_file,
  $keys_controlkey   = $ntp::params::keys_controlkey,
  $keys_requestkey   = $ntp::params::keys_requestkey,
  $keys_trusted      = $ntp::params::keys_trusted,
  $package_ensure    = $ntp::params::package_ensure,
  $package_name      = $ntp::params::package_name,
  $panic             = $ntp::params::panic,
  $preferred_servers = $ntp::params::preferred_servers,
  $restrict          = $ntp::params::restrict,
  $interfaces        = $ntp::params::interfaces,
  $servers           = $ntp::params::servers,
  $service_enable    = $ntp::params::service_enable,
  $service_ensure    = $ntp::params::service_ensure,
  $service_manage    = $ntp::params::service_manage,
  $service_name      = $ntp::params::service_name,
  $udlc              = $ntp::params::udlc
) inherits ntp::params {

  if $autoupdate {
    notice('autoupdate parameter has been deprecated and replaced with package_ensure.  Set this to latest for the same behavior as autoupdate => true.')
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  class { '::ntp::install': } ->
  class { '::ntp::config': } ~>
  class { '::ntp::service': }
}
