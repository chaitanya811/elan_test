# vmware-running?
Facter.add("vmtools_version") do
  setcode do
    Facter::Util::Resolution::exec('/usr/bin/vmware-toolbox-cmd -v')
  end
end
