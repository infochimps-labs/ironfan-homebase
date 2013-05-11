# 
# Storm cluster
# 

Ironfan.cluster 'tri' do
  cloud(:ec2) do
    permanent           false
    availability_zones ['us-east-1c']
    flavor              'm1.large'
    backing             'ebs'
    image_name          'ironfan-precise'
    bootstrap_distro    'ubuntu12.04-ironfan'
    chef_client_script  'client.rb'
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
  role                  :package_set,     :last
  role                  :minidash,        :last
  role                  :zabbix_agent, :last
  cloud(:ec2).security_group("zabbix_agent")

  # This should eventually go in org_users
  role                  :the_village

  role                  :org_base
  role                  :org_users
  role                  :org_final,       :last
  role                  :deploy_keys

  role                  :zookeeper_client ; cloud(:ec2).security_group(:zookeeper_client)

  recipe                "log_integration::logrotate"

  # The config server contains Zookeeper config for Storm and Kafka, as well
  # as runs the Storm master server (Nimbus).
  facet :master do
    cloud(:ec2).flavor('m1.small')
    instances           1

    role                :storm_master
    # Waiting for https://github.com/nathanmarz/storm/pull/329 to hit mainline
    role                :storm_ui
    
    volume(:storm) do
      size              8
      keep              true
      device            '/dev/sdj' # note: will appear as /dev/xvdj on modern ubuntus
      mount_point       '/data/storm'
      attachable        :ebs
      snapshot_name     :blank_xfs
      resizable         true
      create_at_launch  true
      tags :nimbus_data => false, :persistent => true, :local => false, :bulk => true, :fallback => false
    end
  end

  # Storm workers (supervisors) are in their own nodes.
  facet :worker do
    cloud(:ec2) do
      bits        64
      flavor      'c1.xlarge'
    end
    
    instances     4

    recipe        'dds::install_from_git'
    role          :storm_worker           ; cloud(:ec2).security_group(:kafka_client)
    # facet_role.override_attributes({
    #   # dds: { deploy_pack: 'git@github.com:[deploypack].git' }
    # })
  end
end