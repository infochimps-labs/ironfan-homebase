name        'resque_server'
description 'installs resque and launches its redis and web services'

run_list *%w[
  redis::server
  resque::default
  resque::dashboard
  ]
