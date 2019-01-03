# vmware installed?
Facter.add("vmtools_installed") do
  setcode do
    File.exists?('/usr/bin/vmware-toolbox-cmd')
  end
end
