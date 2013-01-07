USE_LOCAL         = false                               unless defined? USE_LOCAL
LOCAL_PATH        = "vendor"                            unless defined? LOCAL_PATH
PANTRY_REPO       = 'infochimps-labs/ironfan-pantry'    unless defined? PANTRY_REPO
PANTRY_BRANCH     = 'master'                            unless defined? PANTRY_BRANCH

def github_cookbook(name, repo, rel, branch)
  if USE_LOCAL
    r_name = repo.split('/')[1]
    cookbook name, path: "#{LOCAL_PATH}/#{r_name}/#{rel}"
  else
    cookbook name, github: repo, protocol: 'ssh', rel: rel, branch: branch
  end
end

def pantry_cookbook(name)
  github_cookbook name, PANTRY_REPO, ('cookbooks/' + name), PANTRY_BRANCH
end

def org_cookbook(name)
  cookbook name, path: "org_cookbooks/#{name}"
end