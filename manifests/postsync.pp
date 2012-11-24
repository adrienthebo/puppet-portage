define gentoo::postsync ($content, $ensure=present) {
  file { "gentoo_postsync_${name}":
    path    => "/etc/portage/postsync.d/${name}",
    content => template("gentoo/postsync.sh.erb"),
    mode    => 755,
    ensure  => $ensure,
    require => File["/etc/portage/postsync.d"],
  }
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
