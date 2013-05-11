#
# Kafka cluster
#

Ironfan.cluster 'kfk' do
  cloud(:ec2) do
    availability_zones ['us-east-1c']
    flavor              'm1.large'
    image_name          'ironfan-precise'
    mount_ephemerals
  end

  environment           :development

  role                  :systemwide,    :first
  cloud(:ec2).security_group :systemwide
  role                  :ssh
  cloud(:ec2).security_group(:ssh).authorize_port_range 22..22
  role                  :nfs_client
  cloud(:ec2).security_group :nfs_client
  role                  :set_hostname

  recipe                'log_integration::logrotate' 

  role                  :volumes
  role                  :package_set,   :last
  role                  :minidash,      :last
  role                  :zabbix_agent,  :last
  cloud(:ec2).security_group("zabbix_agent")

  role                  :org_base
  role                  :org_users
  role                  :org_final,      :last

  role                  :hadoop
  role                  :hadoop_s3_keys
  recipe                'hadoop_cluster::config_files', :last

  recipe                "log_integration::logrotate"

  cloud(:ec2).security_group(:hadoop_client)

  # This node is the data storage server. It accepts data and queues it in
  # the Kafka server.
  facet :storage do
    instances           1

    role                :nfs_client, :first
    role                :zookeeper_client ; cloud(:ec2).security_group(:zookeeper_client)
    role                :kafka_broker     ; cloud(:ec2).security_group(:kafka_server).authorize_group(:kafka_client)
    role                :kafka_contrib
    role                :hadoop_datanode

    facet_role.override_attributes({
        :hadoop => { :datanode => { :run_state => :stop }},
        :kafka => {
          :contrib => {
            :app => {
              :s3_archiver => {
                :type =>      's3_consumer',
                :group_id => 's3_archiver',
                :daemons =>   1,
                :run_state => :nothing,
                :topic =>     'raw',
                :options => {
                  # :bucket => '[archive bucket]',
                  :batch_size => (10 * 2 ** 10),
                }
              },
            }
          }
        },
      })

    # Reliable store for the Kafka store
    # TODO Have Kafka write to this location
    volume(:kafka) do
      size                32
      keep                true
      device              '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
      mount_point         '/data'
      attachable          :ebs
      snapshot_name       :blank_xfs
      resizable           true
      create_at_launch    true
      tags :kafka_journal => false, :persistent => true, :local => false, :bulk => true, :fallback => false
    end
  end

  #
  # Hadoop Daemon run states
  #
  facet(:kfk).facet_role.override_attributes({
      :hadoop => {
        :datanode     => { :run_state => :stop,  },
      },
    })
end
