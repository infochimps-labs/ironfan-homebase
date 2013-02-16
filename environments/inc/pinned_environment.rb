# Make sure that we're in the correct branch before we sync
error_msg = "Not on the #{self.name} branch, can't sync its environment"
`git status | grep -q "On branch #{self.name}"`
raise error_msg unless ($?.to_i == 0)

from_file File.expand_path("cookbook_versions.rb", File.dirname(__FILE__))

# Pin all cookbooks to the build version set in cookbooks
$cookbooks.each_pair {|name,version| cookbook name, "= #{version}" }
