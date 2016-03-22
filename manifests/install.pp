# rdiff_backup::install class
class rdiff_backup::install {

  # We need some variables out of rdiff_backup::params
  include rdiff_backup::params

  # Install rdiff_backup
  package { $rdiff_backup::params::package:
    ensure => present,
  }


}
