#
# Sandbox cluster -- use this for general development
#
Ironfan.cluster 'sandbox' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-natty'
    bootstrap_distro    'ubuntu10.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
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

  facet :simple do
    instances           1
  end

  facet :raid_demo do
    instances           1
    cloud.flavor        'm1.large'
    recipe              'volumes::build_raid', :first

    cloud.mount_ephemerals
    raid_group(:md0) do
      defaults
      device            '/dev/md0'
      mount_point       '/raid0'
      level             0
      sub_volumes       [:ephemeral0, :ephemeral1] # , :ephemeral2, :ephemeral3]
    end
  end

  cluster_role.override_attributes({
    })
end
