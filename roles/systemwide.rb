name        'systemwide'
description 'top level attributes, applies to all nodes'

run_list *%w[
  users::ubuntu
  build-essential
  motd
  zsh
  emacs
  ntp
  ]

default_attributes({
  :java        => { # use oracle java
    :install_flavor => 'oracle_via_webupd8',
  },
})
