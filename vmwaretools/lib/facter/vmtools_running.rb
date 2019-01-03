# vmware running?
Facter.add("vmtools_running") do
  setcode do
    Facter::Util::Resolution::exec('ps -ef|grep vmtoolsd|grep -v grep &>/dev/null && echo true || echo false')
  end
end
