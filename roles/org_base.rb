name 'org_base'
description 'Attributes and recipes applied to EVERY node in the organization'

default_attributes({
  # :nfs                  => { :discover_in => 'control' } ,
  # :zabbix =>  { :server => { :discover_in => 'control' } },
  :discovers => {  # FIXME: Replace with the above, once silverware 3.3 is everywhere
    :nfs        => 'control',
    :zabbix     => { :server => 'control' },
  },
  :route53 => { :zone => "YOURDOMAIN.com" },
})

run_list(*%w[
])
