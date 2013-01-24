name        'hadoop_hive'
description 'loads and configures hive'

run_list *%w[
  hadoop_cluster::hive
  hadoop_cluster::hive_config
  hadoop_cluster::config_files
  hadoop_cluster::hive_mysql_setup
]

override_attributes({
  :hadoop => {
    :hive => {
       :mysql_user_password => Chef::Config[:hive_mysql_user_password]
    },
  },
})
