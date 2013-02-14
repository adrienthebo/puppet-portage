# = Class: portage
#
# Configure the Portage package management system
#
# == Parameters
#
# # [*make_conf*]
#
# The path to make.conf.
#
# As of 2012-09-09 new systems will use /etc/portage/make.conf, but on older
# systems this can be /etc/make.conf.
#
# # All the other parameters are taken from make.conf(5) man page
# == Example
#
#     class { 'portage':
#       global_use     => 'mmx sse sse2',
#       features       => 'sandbox parallel-fetch parallel-install',
#       mirrors        => 'http://www.gtlib.gatech.edu/pub/gentoo rsync://mirror.the-best-hosting.net/gentoo-distfiles',
#       sync           => 'rsync://rsync.gentoo.org/gentoo-portage',
#       accept_license => '* -@EULA dlj-1.1 IBM-J1.5',
#     }
#
# == See Also
#
#  * emerge(1) http://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
#  * make.conf(5) http://dev.gentoo.org/~zmedico/portage/doc/man/make.conf.5.html

class portage (
  $accept_chosts                      = undef,
  $accept_keywords                    = undef,
  $accept_license                     = undef,
  $accept_properties                  = undef,
  $ccache_dir                         = undef,
  $ccache_size                        = undef,
  $cflags                             = undef,
  $cxxflags                           = undef,
  $chost                              = undef,
  $clean_delay                        = undef,
  $collision_ignore                   = undef,
  $config_protect                     = undef,
  $config_protect_mask                = undef,
  $distdir                            = undef,
  $doc_symlinks_dir                   = undef,
  $ebeep_ignore                       = undef,
  $emerge_default_opts                = undef,
  $emerge_log_dir                     = undef,
  $emerge_warning_delay               = undef,
  $epause_ignore                      = undef,
  $extra_econf                        = undef,
  $features                           = undef,
  $fetchcommand                       = undef,
  $fclags                             = undef,
  $fflags                             = undef,
  $gentoo_mirrors                     = undef,
  $install_mask                       = undef,
  $ldflags                            = undef,
  $makeopts                           = undef,
  $nocolor                            = undef,
  $pkgdir                             = undef,
  $port_logdir                        = undef,
  $port_logdir_clean                  = undef,
  $portage_binhost                    = undef,
  $portage_binhost_header_uri         = undef,
  $portage_binpkg_tar_opts            = undef,
  $portage_bunzip2_command            = undef,
  $portage_bzip2_command              = undef,
  $portage_checksum_filter            = undef,
  $portage_compress                   = undef,
  $portage_compress_flags             = undef,
  $portage_compress_exclude_suffixes  = undef,
  $portage_elog_classes               = undef,
  $portage_elog_system                = undef,
  $portage_elog_command               = undef,
  $portage_elog_mailuri               = undef,
  $portage_elog_mailsubject           = undef,
  $portage_fetch_checksum_try_mirrors = undef,
  $portage_fetch_resume_min_size      = undef,
  $portage_gpg_dir                    = undef,
  $portage_gpg_key                    = undef,
  $portage_gpg_signing_command        = undef,
  $portage_grpname                    = undef,
  $portage_inst_gid                   = undef,
  $portage_ionice_command             = undef,
  $portage_niceness                   = undef,
  $portage_ro_distdirs                = undef,
  $portage_rsync_initial_timeout      = undef,
  $portage_rsync_extra_opts           = undef,
  $portage_rsync_retries              = undef,
  $portage_sync_stale                 = undef,
  $portage_tmpdir                     = undef,
  $portage_username                   = undef,
  $portage_workdir_mode               = undef,
  $portdir                            = undef,
  $portdir_overlay                    = undef,
  $qa_strict_execstack                = undef,
  $qa_strict_wx_load                  = undef,
  $qa_strict_textrels                 = undef,
  $qa_strict_flags_ignored            = undef,
  $qa_strict_multilib_paths           = undef,
  $qa_strict_prestripped              = undef,
  $resumecommand                      = undef,
  $rpmdir                             = undef,
  $sync                               = undef,
  $uninstall_ignore                   = undef,
  $use                                = undef,
  $make_conf                          = $portage::params::make_conf,
) inherits portage::params {

  include concat::setup

  # Add requires for Package provider
  Package {
    require => Concat[$make_conf],
  }

  file {
    '/etc/portage/package.keywords':
      ensure  => directory;
    '/etc/portage/package.mask':
      ensure  => directory;
    '/etc/portage/package.unmask':
      ensure  => directory;
    '/etc/portage/package.use':
      ensure  => directory;
    '/etc/portage/postsync.d':
      ensure  => directory;
  }

  exec { 'changed_makeconf_use':
    command     => '/usr/bin/emerge --reinstall=changed-use @world',
    require     => Concat[$make_conf],
    refreshonly => true,
  }

  concat { $make_conf:
    owner   => root,
    group   => root,
    mode    => 644,
    notify  => Exec['changed_makeconf_use'],
  }

  concat::fragment { 'makeconf_base':
    target  => $make_conf,
    content => template('portage/makeconf.base.conf.erb'),
    order   => 00,
  }
}
