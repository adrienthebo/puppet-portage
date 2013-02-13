# = Define: portage::eselect
#
# Wrapper around eselect configuration tool
#
# == Parameters
#
# [*set*]
#
# The value of the eselect module
#
# == Example
#
#     portage::eselect { 'ruby':
#       set => 'ruby19',
#     }
#
define portage::eselect (
  $set = undef,
) {

  exec { "eselect_${name}":
    command => "/usr/bin/eselect ${name} set ${set}",
  }
}
