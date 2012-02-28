#
# Science cluster -- persistent HDFS
#
Ironfan.cluster 'elastic_hadoop' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :hadoop_scratch => true, })
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
  role                  :org_final,     :last

  role                  :tuning
  role                  :jruby
  role                  :pig

  role                  :hadoop
  role                  :hadoop_s3_keys
  role                  :hbase_client
  recipe                'hadoop_cluster::config_files', :last
  recipe                'hbase::config_files',          :last

  facet :master do
    instances           1
    role                :hadoop_namenode
    role                :hadoop_jobtracker
    role                :hadoop_secondarynn
    role                :hadoop_tasktracker
    role                :hadoop_datanode
  end

  facet :worker do
    instances           2
    role                :hadoop_datanode
    role                :hadoop_tasktracker
  end

  cluster_role.override_attributes({
      :hadoop => {
        :tasktracker => { :java_heap_size_max => 1400, },
        # lets you rapidly decommission nodes for elasticity
        :balancer    => { :max_bandwidth => (50 * 1024 * 1024) },
        # make mid-flight data much smaller -- useful esp. with ec2 network constraints
        :compress_mapout_codec => 'org.apache.hadoop.io.compress.SnappyCodec',
      },
    })

  # Launch the cluster with all of the below set to 'stop'.
  #
  # After initial bootstrap,
  # * set the run_state to :start in the lines below
  # * run `knife cluster sync hadoop_demo-master` to push those values up to chef
  # * run `knife cluster kick hadoop_demo-master` to re-converge
  #
  # Once you see 'nodes=1' on jobtracker (host:50030) & namenode (host:50070)
  # control panels, you're good to launch the rest of the cluster.
  #
  facet(:master).facet_role.override_attributes({
      :hadoop => {
        :namenode    => { :run_state => :stop, },
        :secondarynn => { :run_state => :stop, },
        :jobtracker  => { :run_state => :stop, },
        :datanode    => { :run_state => :stop, },
        :tasktracker => { :run_state => :stop, },
      },
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
    tags( :hadoop_data => true, :zookeeper_data => true, :persistent => true, :local => false, :bulk => true, :fallback => false )
  end

end
