require 'chef/mixin/deep_merge'

# Default attributes to include in every environment
$_default_environment = {
  :discovers => {
    :nfs        => 'control',
    :zabbix     => { :server => 'control' },
  },
  :route53 => { :zone => "YOURDOMAIN.com" },
}
