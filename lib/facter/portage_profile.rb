# make_profile.rb
Facter.add("portage_profile") do
  confine :operatingsystem => :gentoo
  setcode do
    %x{eselect --brief --no-color profile show}.strip
  end
end
