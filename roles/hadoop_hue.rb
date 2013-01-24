name 'hadoop_hue'
description 'Installs hadoop_hue.'

run_list %w[
  hadoop_cluster::hue
  hadoop_cluster::hue_config
  hadoop_cluster::hue_mysql_setup
]

override_attributes({
                      :hadoop => {
                        :hue => {
                          :mysql_user_password => Chef::Config[:hive_mysql_user_password]
                        },
                        :jobtracker => {
                          :plugins => ['org.apache.hadoop.thriftfs.ThriftJobTrackerPlugin'],
                        },
                        :namenode => {
                          :plugins => ['org.apache.hadoop.thriftfs.NamenodePlugin'],
                        },
                        :datanode => {
                          :plugins => ['org.apache.hadoop.thriftfs.DatanodePlugin'],
                        },
                        :thrift => {
                          :port => 10090,
                        },
                      }
                    })
