define gentoo::keywords ($source, $ensure=present) {
  file { "gentoo_keywords_${name}":
    path    => "/etc/portage/package.keywords/${name}",
    source  => "${source}",
    ensure  => $ensure,
    require => File["/etc/portage/package.keywords"],
  }
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
