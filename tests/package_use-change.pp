# change use
package_use { 'mysql-server':
  package     => "dev-db/mysql",
  use_flags   => ['cluster', 'community'],
  target      => "/tmp/mysql",
}

# vim: set autoindent softtabstop=2 expandtab textwidth=80 shiftwidth=2:
