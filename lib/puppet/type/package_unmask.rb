require File.expandpath(File.join(File.dirname(__FILE__),'..','property','portage_version'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','property','portage_slot'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','parameter','portage_name'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','util','portage'))

Puppet::Type.newtype(:package_unmask) do
  @doc = "Unmask packages in portage.

      package_unmask { 'app-admin/puppet-2.7.1':
        target  => 'puppet',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true, :parent => Puppet::Parameter::PortageName)

  newproperty(:version, :parent => Puppet::Property::PortageVersion)

  newproperty(:slot, :parent => Puppet::Property::PortageSlot)

  newproperty(:target) do
    desc "The location of the package.unmask file"

    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end

    # Allow us to not have to specify an absolute path unless we really want to
    munge do |value|
      if !value.match(/\//)
        value = "/etc/portage/package.unmask/" + value
      end
      value
    end
  end
end
