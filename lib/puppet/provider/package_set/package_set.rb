require 'fileutils'

Puppet::Type.type(:package_set).provide(:package_set) do
  @doc = 'Provider to install, update, and remove portage sets.'

  commands :emerge => '/usr/bin/emerge', :eix => '/usr/bin/eix'

  def create
    # Install the set using --noreplace to prevent needles re-installs of packages.
    emerge "--noreplace", "@#{resource[:name]}"
  end

    def destroy
    # Remove the whole set using --depclean
    emerge "--depclean", "@#{resource[:name]}"
  end

    def exists?
    # Cross reference /var/lib/portage/world_sets with /etc/portage/sets/* to check if a set is installed.
    #
    # If it is loop through /etc/portage/sets/setname and verify all listed packages are installed.
        File.readlines('/var/lib/portage/world_sets').each do | line |
      if line.include?(resource[:name]) then
        installed_packages = eix '--nocolor', '--pure-packages', '--stable', '--installed', '--format', '<category>/<name>\n'
        File.readlines("/etc/portage/sets/#{resource[:name]}").each do | pkg_line |
          unless installed_packages.include?(pkg_line) then
            return false
          end
        end
      else
        return false
      end
    end
    end

end
