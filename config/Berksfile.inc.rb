USE_LOCAL       = false                                 if USE_LOCAL.nil?
LOCAL_PATH      = "vendor"                              if LOCAL_PATH.nil?
OPSCODE_REPO    = 'infochimps-labs/opscode_cookbooks'   if OPSCODE_REPO.nil?
PANTRY_REPO     = 'infochimps-labs/ironfan-pantry'      if PANTRY_REPO.nil?
ENTERPRISE_REPO = 'infochimps/ironfan-enterprise'       if ENTERPRISE_REPO.nil?

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

def enterprise_cookbook(name)
  github_cookbook name, ENTERPRISE_REPO, ('cookbooks/' + name)
end

def org_cookbook(name)
  cookbook name, path: "org_cookbooks"
end