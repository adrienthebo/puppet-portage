require File.expand_path(File.join(File.dirname(__FILE__),'..','util','portage'))
require 'puppet/property'

class Puppet::Property::PortageSlot < Puppet::Property
  desc "A properly formatted slot string"

  validate do |value|
    unless Puppet::Util::Portage.valid_slot? value
      raise ArgumentError, "#{name} must be a properly formatted slot"
    end
  end
end
