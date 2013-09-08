Puppet::Type.type(:eselect).provide(:eselect) do

  commands :eselect => '/usr/bin/eselect'

  def self.instances
    output = Facter.to_hash.keep_if { |key, value| (key =~ /^eselect_.+/) }
    output.map { |name, set| new(:name => name.sub(/^eselect_/, ''), :set => set) }
  end

  def set
    Facter.value('eselect_' + resource[:name].sub(':', '_'))
  end

  def set=(target)
    m, subm = resource[:name].split(':', 2)
    if subm
       eselect(m, 'set', subm, target)
    else
       eselect(resource[:name], 'set', target)
    end
  end
end
