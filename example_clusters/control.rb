#
# Command and control cluster
#
# take note that permanent true is commented out, this may or may not not be ideal for you


Ironfan.cluster 'control' do
  cloud(:ec2) do
    # permanent           true
    availability_zones ['us-east-1c']
    flavor              't1.micro'
    backing             'ebs'
    image_name          'ironfan-precise'
    bootstrap_distro    'ubuntu12.04-ironfan'
    chef_client_script  'client.rb'
    mount_ephemerals
  end

  environment           :development

  role                  :systemwide ; cloud(:ec2).security_group :systemwide
  role                  :chef_client
  role                  :ssh
  cloud(:ec2).security_group(:ssh).authorize_port_range 22..22
  role                  :set_hostname

  role                  :volumes
  role                  :package_set,   :last
  role                  :minidash,      :last

  role                  :org_base
  role                  :org_users
  role                  :org_final,     :last

  facet :nfs do
    role                :nfs_server
    cloud(:ec2).security_group(:nfs_server).authorize_group :nfs_client

    facet_role do
      override_attributes({
          :nfs => { :exports => {
              '/home' => { :name => 'home', :nfs_options => '*.internal(rw,no_root_squash,no_subtree_check)' }}},
        })
    end

    volume(:home_vol) do
      size              20
      keep              true
      device            '/dev/sdh' # note: will appear as /dev/xvdh on modern ubuntus
      mount_point       '/home'
      attachable        :ebs
      snapshot_name     :blank_xfs
      resizable         true
      create_at_launch  true
      tags( :persistent => true, :local => false, :bulk => false, :fallback => false )
    end
  end

# facet copied from awsdemo
  facet :dashpot do
    instances           1
    cloud(:ec2).permanent false
# sizing it from micro to large because dashpot needs it to be able to process in a reasonable amount of time
    cloud(:ec2).flavor 'm1.large'

    role                :nfs_client,    :first
    role                :web_server
    role                :zabbix_agent,  :last

    role                :mongodb_server
    role                :mongodb_client
    role                :redis_server

    role                :ironfan_api
    role                :chef_biographer
    role                :cube_server
    role                :dashpot_web
    role                :vayacondios_server

    cloud(:ec2).security_group("control-dashpot") do
      authorize_port_range 6006
      authorize_port_range 80
    end

#hint if for example cube is not necessary then remove it here and the corresponding role above
    facet_role.override_attributes({
      :ironfan_api => {
        # :deploy_version => 'staging'
      },
      :cube => {
        # :deploy_version => 'staging',
        :mongodb => {
          :expire_metrics_horizon => "1000 * 60 * 60 * 24 * 7"
        }
      },
      :dashpot => {
        # :deploy_version => 'master',
        :engine_components => {
          :cube  => [:visualizations],
          :flows => [:flows],
          :jobs  => [:jobs],
          :clusters => %w{systems clusters servers start stop inspect}.map(&:to_sym)
        }
      }
    })
  end


  facet :zabbix do
    cloud(:ec2).flavor 'm1.large'
    role :nfs_client, :first
    role :web_server
    recipe 'nginx'
    role :zabbix_server
    facet_role.override_attributes({
      :zabbix_integration => {
        :active_users => ['temujin9','dhruv','aseever','huston'],
        :user_groups  => {
          'First responders'  => {:users => %w[temujin9]},
          'Second responders' => {:users => %w[aseever]}
        }
      }
    })
  end


end
