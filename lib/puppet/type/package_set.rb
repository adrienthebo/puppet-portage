Puppet::Type.newtype(:package_set) do
  @doc = 'Type to install, update, and remove portage sets.'              
  ensurable

  newparam(:name) do
    desc 'The name of the set without @'
    isnamevar
    validate do | value |
    end
  end

end
