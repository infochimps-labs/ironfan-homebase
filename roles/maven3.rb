name 'maven3'
description 'Maven.'

run_list *%w[
    java
    maven::maven3
    maven::config_files
]
