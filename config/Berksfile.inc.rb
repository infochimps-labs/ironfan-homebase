conf_file = File.join(File.dirname(__FILE__), 'Berksfile.conf')

# Move the old file to the right place
old_conf_file = "#{conf_file}.rb"
if ((File.exists? old_conf_file) && (not File.exists? conf_file))
  require 'fileutils'
  puts "Moving #{old_conf_file} to #{conf_file}"
  FileUtils.mv(old_conf_file, conf_file)
end

if File.exists? conf_file
  require 'parseconfig'
  ParseConfig.new(conf_file).params.each_pair {|k,v| ENV[k] = v unless ENV[k] }
end

# ENV['USE_LOCAL']         = false       # This is already default
ENV['LOCAL_PATH']        = "vendor"                            unless ENV['LOCAL_PATH']
ENV['PANTRY_REPO']       = 'infochimps-labs/ironfan-pantry'    unless ENV['PANTRY_REPO']
ENV['PANTRY_BRANCH']     = 'master'                            unless ENV['PANTRY_BRANCH']

def github_cookbook(name, repo, rel, branch)
  if ENV['USE_LOCAL']
    r_name = repo.split('/')[1]
    cookbook name, path: "#{ENV['LOCAL_PATH']}/#{r_name}/#{rel}"
  else
    cookbook name, github: repo, protocol: 'ssh', rel: rel, branch: branch
  end
end

def pantry_cookbook(name)
  github_cookbook name, ENV['PANTRY_REPO'], ('cookbooks/' + name), ENV['PANTRY_BRANCH']
end

def org_cookbook(name)
  cookbook name, path: "org_cookbooks/#{name}"
end