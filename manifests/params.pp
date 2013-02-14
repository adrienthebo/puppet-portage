# = Class: portage::params
#
# Contains default values for portage.
#
# == Example
#
# This class does not need to be directly included.
#
class portage::params {
  $procs_plus_one = $::processorcount + 1
  $makeopts       = "-j${procs_plus_one}"
  $make_conf      = '/etc/portage/make.conf'
}
