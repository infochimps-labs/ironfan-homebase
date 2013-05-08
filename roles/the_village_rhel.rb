name        'the_village_rhel'
description 'These are all of the things that trogdor burns onto an AMI'

run_list %w[
java

ant
boost
build-essential
emacs
git
jruby
jruby::gems
nodejs
ntp
openssl
pig::install_from_release
hadoop_cluster::add_cloudera_repo
runit
thrift
xfs
xml
zlib
zsh

role[package_set]
role[maven]
]

override_attributes({
  :java        => { # use oracle java
    :install_flavor => 'oracle',
    :jdk => { 6 => { :x86_64 => {
      :url        => 'http://artifacts.chimpy.us.s3.amazonaws.com/tarballs/jdk-6u32-linux-x64.bin',
      :checksum   => '269d05b8d88e583e4e66141514d8294e636f537f55eb50962233c9e33d8f8f49'
      } } }
  },
  :package_set    => { :install   => %w[ base dev sysadmin text python emacs ] },
  :apt            => { :cloudera  => { :force_distro => 'maverick',  }, },
})
