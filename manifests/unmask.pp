define gentoo::unmask ($source, $ensure=present) {
  file { "gentoo_unmask_${name}":
    path    => "/etc/portage/package.unmask/${name}",
    source  => "${source}",
    ensure  => $ensure,
    require => File["/etc/portage/package.unmask"],
  }
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
