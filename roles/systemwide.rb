name        'systemwide'
description 'top level attributes, applies to all nodes'

run_list *%w[
  apt::update_immediately
  build-essential
  motd
  zsh
  emacs
  ntp
  chef_handler
  chef_handler::json_file
  ]

default_attributes({
  :java        => { # use oracle java
    :install_flavor => 'oracle_via_webupd8',
  },
})
