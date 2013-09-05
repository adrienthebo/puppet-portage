require File.expandpath(File.join(File.dirname(__FILE__),'..','property','portage_version'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','property','portage_slot'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','parameter','portage_name'))
require File.expandpath(File.join(File.dirname(__FILE__),'..','util','portage'))

Puppet::Type.newtype(:package_keywords) do
  @doc = "Set keywords for a package.

      package_keywords { 'app-admin/puppet':
        keywords  => ['~x86', '-hppa'],
        target  => 'puppet',
      }"

  ensurable do
    defaultvalues
    defaultto :present
  end

  newparam(:name, :namevar => true, :parent => Puppet::Parameter::PortageName)

  newproperty(:version, :parent => Puppet::Property::PortageVersion)

  newproperty(:slot, :parent => Puppet::Property::PortageSlot)

  newproperty(:keywords) do
    desc "The keywords(s) to use"

    validate do |value|
      raise ArgumentError, "Keyword cannot contain whitespace" if value =~ /\s/
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
    desc "The location of the package.keywords file"

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
        value = "/etc/portage/package.keywords/" + value
      end
      value
    end
  end
end
