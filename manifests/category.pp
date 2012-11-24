define gentoo::category {
  config { "gentoo_category_${name}":
    file    => "/etc/portage/categories",
    line    => "$name",
    pattern => "^$name$",
    engine  => "replaceline",
  }
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
