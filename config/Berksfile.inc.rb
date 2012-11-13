USE_LOCAL       = false                                 unless defined? USE_LOCAL
LOCAL_PATH      = "vendor"                              unless defined? LOCAL_PATH
OPSCODE_REPO    = 'infochimps-labs/opscode_cookbooks'   unless defined? OPSCODE_REPO
PANTRY_REPO     = 'infochimps-labs/ironfan-pantry'      unless defined? PANTRY_REPO

def github_cookbook(name, repo, rel)
  if USE_LOCAL
    r_name = repo.split('/')[1]
    cookbook name, path: "#{LOCAL_PATH}/#{r_name}/#{rel}"
  else
    cookbook name, github: repo, protocol: 'ssh', rel: rel
  end
end

def opscode_cookbook(name)
  github_cookbook name, OPSCODE_REPO, name
end

def pantry_cookbook(name)
  github_cookbook name, PANTRY_REPO, ('cookbooks/' + name)
end

def org_cookbook(name)
  cookbook name, path: "org_cookbooks"
end