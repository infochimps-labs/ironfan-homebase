name        "staging"
description "Staging environment"

# Make sure that we're in the staging environment before we sync
`git status | grep -q "On branch staging"`
raise "Not on the staging branch, can't sync the staging environment" unless ($?.to_i == 0)

# Pin all cookbooks to the build version set in cookbooks
from_file File.expand_path("cookbook_versions.rb", File.dirname(__FILE__))
$cookbooks.each_pair {|name,version| cookbook name, "= #{version}" }
