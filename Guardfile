# A sample Guardfile -*- ruby -*-
# More info at https://github.com/guard/guard#readme

# # This is an example with all options that you can specify for guard-process
# guard 'process', :name => 'echo', :command => 'echo', :env => {"ENV1" => "value 1", "ENV2" => "value 2"}, :stop_signal => "KILL"  do
#   watch(%r{^homebase/vendor/[^/]+/(.+)}){|m| fn = "cookbooks/#{m[1]}" ; p [m, fn] ; fn }
# end

# fuckaduck -- there's no way to tell guard NOT to ignore vendor.
# so we nuke it from orbit it's the only way to be sure
Listen::DirectoryRecord::DEFAULT_IGNORED_DIRECTORIES.reject!{ |p| p == 'vendor' }
ignore.directory_record.instance_eval{ @ignoring_patterns.reject!{|patt| patt.to_s =~ /vendor/ } }
ignore /^(?:\.rbx|\.bundle|\.git|\.svn|log|tmp)\//
# /kludge


# ignore %r{.*_flymake\.\w+$} # ignore emacs compilation
filter %r{\.e?rb$}

# run the right knife command on changes within the cookbooks, roles and data_bags directories
guard 'chef' do
  file_chars = '[\w\-\:\.]+'

  # watch files in vendor/foo-pantry/cookbooks/*; act on them if they are symlinked into action
  watch(%r{vendor/[^/]+/((?:cookbooks|roles|data_bags)/#{file_chars})}){|m| m[1] if File.exists?(m[1]) }

  watch(%r{^[^/]*cookbooks/(#{file_chars})/}) # cookbooks and site-cookbooks
  watch(%r{^data_bags/(#{file_chars})/})
  watch(%r{^roles/(#{file_chars})\.(rb|json)\z})
  watch(%r{^environments/(#{file_chars}\.(rb|json))\z})
end
