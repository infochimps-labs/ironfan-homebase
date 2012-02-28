# Manually set all of the service states (see cluster_role below) to 'stop'.
#
# Launch the namenode machine, allow it to converge, and then on that machine
# run `/etc/hadoop/boostrap_hadoop_namenode.sh`.
#
# After initial bootstrap,
# * set the run_state to :start in the lines below
# * run `knife cluster sync bonobo-master` to push those values up to chef
# * run `knife cluster kick bonobo-master` to re-converge
#
# Once you see 'nodes=1' on jobtracker (host:50030) & namenode (host:50070)
# control panels, you're good to launch the rest of the cluster.
#

#
#
# * persistent HDFS --
#
# if you're testing, these recipes *will* work on a t1.micro. just don't use it for anything.
#
Ironfan.cluster 'hb' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hbase_scratch => true, :hadoop_scratch => true })
  end

  environment           :dev

  role                  :systemwide
  role                  :chef_client
  role                  :ssh
  role                  :nfs_client
  role                  :set_hostname

  role                  :volumes
  role                  :package_set,   :last
  role                  :minidash,      :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,      :last

  role                  :tuning
  role                  :jruby
  role                  :pig

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::config_files', :last
  recipe                'hbase::config_files',          :last

  facet :alpha do
    instances 1
    role                  :hadoop_namenode
    role                  :hbase_master
  end
  facet :beta do
    instances 1
    role                  :hadoop_secondarynn
    role                  :hadoop_jobtracker
    role                  :hbase_master
  end
  facet :worker do
    instances 4
    role                  :hadoop_datanode
    role                  :hadoop_tasktracker
    role                  :hbase_regionserver
    role                  :hbase_stargate
    role                  :hbase_thrift
  end

  # This line, and the 'discovers' setting in the cluster_role,
  # enable the hbase to use an external zookeeper cluster
  self.cloud.security_group(self.name).authorized_by_group("zk")

  cluster_role.override_attributes({
      # Look for the zookeeper nodes in the dedicated zookeeper cluster
      :discovers => {
        :zookeeper =>   { :server    => 'zk' }, },
      #
      :hadoop => {
        :namenode    => { :run_state => :start,  },
        :secondarynn => { :run_state => :start,  },
        :datanode    => { :run_state => :start,  },
        :jobtracker  => { :run_state => :stop,   },
        :tasktracker => { :run_state => :stop,   },
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      },
      :hbase          => {
        :master       => { :run_state => :start  },
        :regionserver => { :run_state => :start },
        :stargate     => { :run_state => :start  }, },
      :zookeeper      => {
        :server       => { :run_state => :stop  }, },
    })

  #
  # Attach persistent storage to each node, and use it for all hadoop data_dirs.
  #
  volume(:ebs1) do
    defaults
    size                200
    keep                true
    device              '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :hbase_data => true, :hadoop_data => true, :zookeeper_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
  end

end
