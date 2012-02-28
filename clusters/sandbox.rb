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
    instances           2
  end

  cluster_role.override_attributes({
    })

  #
  # Modify the snapshot ID and attached volume size to suit
  #
  volume(:ebs1) do
    defaults
    size                10
    keep                true
    device              '/dev/sdk' # note: will appear as /dev/xvdk on modern ubuntus
    mount_point         '/data/ebs1'
    attachable          :ebs
    snapshot_name       :blank_xfs
    resizable           true
    create_at_launch    true
    tags( :persistent => true, :local => false, :bulk => true, :fallback => false )
  end
end
