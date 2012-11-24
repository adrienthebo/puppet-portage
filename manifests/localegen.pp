define gentoo::localegen ($value) {
  config { "gentoo_localegen_${name}":
    file    => "/etc/locale.gen",
    line    => "$name $value",
    pattern => "^$name $value$",
    engine  => "replaceline",
  }
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
