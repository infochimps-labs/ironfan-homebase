#
# All of the below override settings in your knife.rb
#
# Put secrets in credentials.rb, not here.
#
Chef::Config.instance_eval do

  #
  # You must at a minimum set your organization
  #

  organization            "organization"

  #
  # The chef server for this organization
  # You must set this if you are not on opscode platform
  #
  # for localhost install
  # chef_server_url "http://localhost:4000/"
  # for vagrants
  # chef_server_url "http://33.33.33.20:4000/"
  # for opscode platform:
  # chef_server_url "https://api.opscode.com/organizations/#{organization}"

  #
  # Validation client name. Home installs of chef server use 'chef-validator' instead
  # validation_client_name  "#{organization}-validator"

  # Path to the key file
  # validation_key          "#{credentials_path}/#{organization}-validator.pem"

  # Override paths to Cluster definitions
  #
  # cluster_path  [ "#{homebase}/clusters", "#{homebase}/vendor/internal/clusters" ]

  # Override paths to Cookbooks
  #
  # cookbook_path  [
  #   "#{homebase}/cookbooks",
  #   "#{homebase}/site-cookbooks",
  #   "#{homebase}/vendor/opscode/cookbooks",
  #   "#{homebase}/vendor/internal/cookbooks",
  #   ]

  # ===========================================================================
  #
  # Amazon EC2 Settings
  #
  # you can remove this section if not in EC2
  #

  # This is org-wide. No dashes or spaces please.
  #
  # Chef::Config.knife[:aws_account_id]           = "XXXX"

  # Best practice is to make per-user accounts w/ IAM, placed in knife-user-YOU.rb --
  # but if you want to use an org-wide AWS key, place it here
  #
  # Chef::Config.knife[:aws_access_key_id]      = "XXXX"
  # Chef::Config.knife[:aws_secret_access_key]  = "YYYY"

  # Add your own AMIs to the hash below
  #
  # Change `NAME_FOR_AMI` to a helpful identifier. For example, our standard
  # Ubuntu 11.04 AMI is `ironfan-natty`: it has lines for each permutation of
  # bit and backing we use:
  #
  #    %w[us-east-1  64-bit  ebs       ironfan-natty ] => { :image_id => 'ami-12345678', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu11.04-ironfan", },
  #    %w[us-east-1  32-bit  ebs       ironfan-natty ] => { :image_id => 'ami-acbdef01', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu11.04-ironfan", },
  #    %w[us-east-1  64-bit  instance  ironfan-natty ] => { :image_id => 'ami-98765432', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu11.04-ironfan", },
  #    # ...
  #    %w[us-west-1  64-bit  instance  ironfan-natty ] => { :image_id => 'ami-ab12ab12', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu11.04-ironfan", },
  #
  # Then a typical cluster definition file might specify
  #
  #   cloud do
  #     image              'ironfan-natty'
  #     flavor             'c1.xlarge'
  #     backing            'ebs'
  #     image_name         'natty'
  #     availability_zones ['us-east-1d']
  #     # ...
  #   end
  #
  # ironfan knows that a c1.xlarge is 64-bit, and that the us-east-1d AZ
  # is in the us-east-1 region, and so chooses the correct AMI.
  #
  Chef::Config[:ec2_image_info] ||= {}
  ec2_image_info.merge!({
      %w[us-east-1  64-bit  ebs  ironfan-natty ] => { :image_id => 'FIXME_IN_KNIFE-ORG.rb', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu10.04-ironfan", },
    })
  Chef::Log.debug("Loaded #{__FILE__}, now have #{ec2_image_info.size} ec2 images")

  # For an AWS cloud, tell knife to use the public hostname not the fqdn
  #
  # knife[:ssh_address_attribute] = 'cloud.public_hostname'

  # if set, uses the system account to log in
  #
  # knife[:ssh_user]              = 'ubuntu'

  # Don't complain about ssh known_hosts
  knife[:host_key_verify]       = false # yeah... so 0.10.7+ uses one, 0.10.4 the other.
  knife[:no_host_key_verify]    = true

  # ===========================================================================
  #
  # Vagrant (VM) Settings
  #
  # you can remove this section if not using VMs

  #
  # Map of facet name to IP address.
  # Final IP address is
  #
  #   {host_network_base}.{host_network_ip_mapping + facet_index}
  #
  # For example, 'cocina-elasticsearch-6' would be '33.33.33.46'
  #
  # host_network_base = '33.33.33'
  # host_network_ip_mapping = {
  #   :chef_server   => 20,
  #   :sandbox       => 30,
  #   :elasticsearch => 40,
  # }

end
