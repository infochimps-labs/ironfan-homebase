name 'hadoop_hue'
description 'Installs hadoop_hue.'

run_list %w[
  hadoop_cluster::hue
]

override_attributes({
                      :hadoop => {
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
