name 'org_base'
description 'Attributes and recipes applied to EVERY node in the organization'

default_attributes({
  :discovers => {
    :nfs        => 'control',
    :zabbix     => { :server => 'control' },
  },
  :route53 => { :zone => "YOURDOMAIN.com" },
})

run_list(*%w[
])
