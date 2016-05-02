#new rdiff_export
define rdiff_backup::rdiff_export (
  $ensure,
  $chroot,
  $readonly,
  $mungesymlinks,
  $path,
  $uid,
  $gid,
  $users,
  $secrets,
  $allow,
  $deny,
  $prexferexec,
  $postxferexec,
  $remote_path,
  $rdiff_server,
  $rdiffbackuptag,
){

  include rsyncd

  $rdiff_name = $name

  create_resources('@@rsyncd::export', {"${rdiff_name}_${::fqdn}" => {
    ensure        => $ensure,
    chroot        => $chroot,
    readonly      => $readonly,
    mungesymlinks => $mungesymlinks,
    path          => $remote_path,
    uid           => $uid,
    gid           => $gid,
    users         => $users,
    secrets       => $secrets,
    allow         => $allow,
    deny          => $deny,
    prexferexec   => $prexferexec,
    postxferexec  => $postxferexec,
    tag           => $rdiffbackuptag
  }})

  create_resources('@@file', { "${rdiff_name}_${::fqdn}" => {
    ensure => directory,
    path   => $remote_path,
    owner  => $uid,
    group  => $gid,
    tag    => $rdiffbackuptag,
  }})

  cron{ $rdiff_name:
    command => "rdiff-backup ${path} ${gid}@${rdiff_server}::${remote_path}",
    user    => $uid,
    hour    => 1,
  }
}
