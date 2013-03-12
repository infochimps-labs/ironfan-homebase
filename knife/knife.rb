#
# organization - selects your cloud environment.
# username     - selects your client key and user-specific overrides
# homebase     - default location for clusters, cookbooks and so forth
#
username            ENV['CHEF_USER'] || ENV['USER']
homebase            ENV['CHEF_HOMEBASE'] ? File.expand_path(ENV['CHEF_HOMEBASE']) : File.expand_path("..", File.realdirpath(File.dirname(__FILE__)))

#
# Additional settings and overrides
#

#
# Clusters, cookbooks and roles
#
cluster_path        [ "#{homebase}/clusters"  ]
cookbook_path       [ "#{homebase}/cookbooks" ]
role_path           [ "#{homebase}/roles"     ]

#
# Keys and cloud-specific settings.
# Be sure all your .pem files are non-readable (mode 0600)
#
credentials_path    File.expand_path("credentials", File.realdirpath(File.dirname(__FILE__)))
client_key_dir      "#{credentials_path}/client_keys"
ec2_key_dir         "#{credentials_path}/ec2_keys"

#
# Load the vendored ironfan lib if present
#
if File.exists?("#{homebase}/vendor/ironfan-knife/lib")
  $LOAD_PATH.unshift("#{homebase}/vendor/ironfan-knife/lib")
end

log_level               :info
log_location            STDOUT
node_name               username
client_key              "#{credentials_path}/#{username}.pem"
cache_type              'BasicFile'
cache_options           :path => "/tmp/chef-checksums-#{username}"

#
# Configure client bootstrapping
#
bootstrap_runs_chef_client true
bootstrap_chef_version  "~> 0.10.4"

#
# Keys for git deploys
#
git_key_files = Dir.glob("#{credentials_path}/git_keys/*.pem")
Chef::Config[:git_keys] = git_key_files.inject({}) do |hsh, file|
  hsh[ File.basename(file, '.pem').to_sym ] = File.read(file)
  hsh
end

def load_if_exists(file) ; load(file) if File.exists?(file) ; end

#
# Ironfan AMIs
#
Chef::Config[:ec2_image_info] ||= {}
ec2_image_info.merge!({
    %w[us-east-1  64-bit  ebs     ironfan-precise  ] => { :image_id => 'ami-29fe7640', :ssh_user => 'ubuntu', :bootstrap_distro => "ubuntu12.04-ironfan", },
  })
Chef::Log.debug("Loaded #{__FILE__}, now have #{ec2_image_info.size} ec2 images")

# Organization-specific settings -- Chef::Config[:ec2_image_info] and so forth
#
# This must do at least these things:
#
# * define Chef::Config.chef_server
# * define Chef::Config.organization
#
#
load_if_exists "#{credentials_path}/knife-org.rb"

# User-specific knife info or credentials
load_if_exists "#{credentials_path}/knife-user-#{username}.rb"

#
# Chef Server - use Hosted Chef by default
#
chef_server_url "https://api.opscode.com/organizations/#{organization}"
