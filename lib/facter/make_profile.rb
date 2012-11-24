# make_profile.rb
Facter.add("make_profile") do
  confine :operatingsystem => :gentoo
  setcode do
    %x{eselect --brief --no-color profile show}.strip
  end
end

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
