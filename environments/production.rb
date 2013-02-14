name        "production"
description "Production environment"

# Make sure that we're in the production branch before we sync
`git status | grep -q "On branch production"`
raise "Not on the production branch, can't sync the production environment" unless ($?.to_i == 0)

# Pin all cookbooks to the build version set in cookbooks
from_file File.expand_path("cookbook_versions.rb", File.dirname(__FILE__))
$cookbooks.each_pair {|name,version| cookbook name, "= #{version}" }
