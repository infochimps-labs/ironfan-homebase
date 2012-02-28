Ironfan.cluster 'control' do

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
  role                  :set_hostname

  role                  :volumes
  role                  :package_set,    :last
  role                  :minidash,       :last
  role                  :tuning,         :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,      :last

  facet :nfs do
    role                :nfs_server
    facet_role do
      override_attributes({
          :nfs => { :exports => { '/home' => { :name => 'home', :nfs_options => '*.internal(rw,no_root_squash,no_subtree_check)' }}},
        })
    end

    volume(:home_vol) do
      defaults
      size                20
      keep                true
      device              '/dev/sdh' # note: will appear as /dev/xvdh on modern ubuntus
      mount_point         '/home'
      attachable          :ebs
      snapshot_name       :blank_xfs
      resizable           true
      create_at_launch    true
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
    end
  end

end
