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

  $eselect_name = "eselect_${name}"
  $eselect_module = inline_template("<%= scope.lookupvar(eselect_name) %>")

  if $eselect_module != $set {
    exec { "eselect_${name}":
      command => "/usr/bin/eselect ${name} set ${set}",
    }
  }
}
