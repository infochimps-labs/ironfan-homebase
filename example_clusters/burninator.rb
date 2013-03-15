#
# Burninator cluster -- populate an AMI with installed software, but no
# services, users or other preconceptions.
#
# The script /tmp/burn_ami_prep.sh will help finalize the machine -- then, just
# stop it and invoke 'Create Image (EBS AMI)'.
#
Ironfan.cluster 'burninator' do
  cloud(:ec2) do
    availability_zones ['us-east-1c']
    # use a c1.xlarge so the AMI knows about all ephemeral drives
    flavor              'c1.xlarge'
    # image_name is per-facet here
    mount_ephemerals
  end

  environment           :_default

  role                  :ssh              ; cloud(:ec2).security_group(:ssh).authorize_port_range 22..22

  #
  # A minimalist facet for testing bootstrap code
  #
  facet :homestar do
    ec2 do
      image_name        'precise'
      bootstrap_distro  'ubuntu12.04-ironfan'
    end

    recipe              'users::ubuntu'

    facet_role.override_attributes({
        :java           => { :install_flavor => 'oracle_via_webupd8' },
        :package_set    => { :install   => %w[ base dev sysadmin text python emacs ] },
        :apt            => { :cloudera  => { :force_distro => 'maverick',  }, },
      })
  end

  #
  # A throwaway facet for AMI generation
  #
  facet :trogdor do
    instances           1

    cloud(:ec2) do
      image_name        'precise' # Leave set at vanilla precise
      bootstrap_distro  'ubuntu12.04-ironfan'
      chef_client_script  'client.rb'
    end

    recipe              'cloud_utils::burn_ami_prep'
    role                :the_village

    # # It's handy to have the root volumes not go away with the machine.
    # # It also means you can find yourself with a whole ton of stray 8GB
    # # images once you're done burninatin' so make sure to go back and
    # # clear them out
    # volume(:root).keep    true
  end

  #
  # Used to test the generated AMI.
  #
  facet :village do
    instances     1
    # Once the AMI is burned, add a new entry in your knife configuration -- see
    # knife/example-credentials/knife-org.rb. Fill in its name here:
    cloud(:ec2).image_name    'ironfan-precise'

    role                :the_village
  end

end
