require File.expand_path(File.join(File.dirname(__FILE__),'..','property','portage_version'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','property','portage_slot'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','parameter','portage_name'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','util','portage'))

Puppet::Type.newtype(:package_use) do
  @doc = "Set use flags for a package.

      package_use { 'app-admin/puppet':
        use    => ['augeas', '-rrdtool'],
        target => 'puppet',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true, :parent => Puppet::Parameter::PortageName)

  newproperty(:version, :parent => Puppet::Property::PortageVersion)

  newproperty(:slot, :parent => Puppet::Property::PortageSlot)

  newproperty(:use) do
    desc "The flag use flag(s) to apply"

    validate do |value|
      raise ArgumentError, "Use flag cannot contain whitespace" if value =~ /\s/
    end

    def insync?(is)
      is == @should
    end

    def should
      if defined? @should
        if @should == [:absent]
          return :absent
        else
          return @should
        end
      else
        return nil
      end
    end

    def should_to_s(newvalue = @should)
      newvalue.join(" ")
    end

    def is_to_s(currentvalue = @is)
      currentvalue = [currentvalue] unless currentvalue.is_a? Array
      currentvalue.join(" ")
    end

  end

  newproperty(:target) do
    desc "The location of the package.use file"

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
        value = "/etc/portage/package.use/" + value
      end
      value
    end
  end
end
