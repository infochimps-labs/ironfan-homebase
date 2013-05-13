name 'apt_repository'
description 'Creates an apt-repository mirroring upstream Cloudera and Webupd8'

run_list %w[
  repo::default
  repo::keys
  repo::apt
  repo::apache_config
]
