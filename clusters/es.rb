Ironfan.cluster 'es' do
  cloud(:ec2) do
    defaults
    # permanent           true
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals(:tags => { :elasticsearch_scratch => true }) if (Chef::Config.cloud == 'ec2')
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

  role                  :tuning,        :last

  facet :elasticsearch do
    num_nodes =         3
    instances           num_nodes
    recipe              'volumes::build_raid', :first
    #
    role                :elasticsearch_server
    role                :elasticsearch_client

    facet_role.override_attributes({
        :elasticsearch => {
          :expected_nodes        => num_nodes,
          :recovery_after_nodes  => num_nodes,
          :s3_gateway_bucket     => "elasticsearch.#{Chef::Config[:organization]}.chimpy.us",
          :server                => { :run_state => :start }
        }
      })

    raid_group(:md0) do
      defaults
      device            '/dev/md0'
      mount_point       '/raid0'
      level             0
      sub_volumes       [:ephemeral0, :ephemeral1, :ephemeral2, :ephemeral3]
    end if (Chef::Config.cloud == 'ec2')
  end

end
