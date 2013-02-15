#
# This file will be managed by Ironfan Continuous Integration. Please don't
# modify directly; your modifications will be overwritten.
#

# Make sure that we're in the correct branch before we sync
error_msg = "Not on the #{self.name} branch, can't sync its environment"
`git status | grep -q "On branch #{self.name}"`
raise error_msg unless ($?.to_i == 0)

$cookbooks = {}
# IRONFAN CI WILL FILL THIS HASH WITH COOKBOOKS BY VERSION

# Pin all cookbooks to the build version set in cookbooks
$cookbooks.each_pair {|name,version| cookbook name, "= #{version}" }
