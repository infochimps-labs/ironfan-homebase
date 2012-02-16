Overview
========

**@sya**: replace this section with a short overview of ironfan



## Getting started

Before you start, you may wish to fork the repo as you'll be making changes to personalize it for your platform.

Clone the repo. It will produce the directory we will call `homebase` from now on:

        git clone https://github.com/infochimps-labs/ironfan-homebase homebase
        cd homebase
        git submodule update --init

Detailed instructions will now be in the file [`notes/INSTALL.md`]() **@sya please make this a link to wiki page**


__________________________________________________________________________

# Ironfan Installation Instructions

Every Chef installation needs a Chef Homebase. Chef Homebase is the place where cookbooks, roles, config files and other artifacts for managing systems with Chef will live. We strongly advise you to store this homebase in a version control system such as Git and to treat it like source code.

### Conventions

In all of the below,

* `{homebase}`: the directory that holds your chef cookbooks, roles and so forth. For example, this file is in `{homebase}/README.md`.

* `{username}` identifies your personal chef client name: the thing you use to log into the chef WebUI.

* `{organization}`: identifies the credentials set and cloud settings to use.  If your chef server is on the Opscode platform (try it! it's super-easy), use your organization name (the last segment of your chef_server url). If not, use an identifier you deem sensible.

Installation
============

** @sya -- while doing your runthrus, first do:

       rvm gemset create testing
       rvm gemset use    testing
       gem list                  # will show nearly nothing
       gem install bundler
       # now carry on with the instructions.

Before you start, you may wish to fork the repo as you'll be making changes to personalize it for your platform.

1. Clone the repo. It will produce the directory we will call `homebase` from now on:

        git clone https://github.com/infochimps-labs/ironfan-homebase homebase
        cd homebase
        git submodule update --init
        # optional: set each submodule to its master branch
        git submodule foreach git checkout master

2. Install the ironfan gem (you may need to use `sudo`):

        gem install ironfan

3. Set up your [knife.rb](http://help.opscode.com/faqs/chefbasics/knife) file.

  - _New to Chef_: If you don't have an existing chef setup, follow steps in
   [knife/README.md](https://github.com/sya/ironfan-homebase/blob/master/knife/README.md)
   to set up `~/.chef` and its credentials (`knife/{organization}-credentials`)
   folder. By default, we assume your chef-server username is `$USER` and the 
   homebase is the parent directory of your knife.rb, but you can customize 
   them by setting either or both of these environment variables:

        export CHEF_USER={username} CHEF_HOMEBASE={homebase}

  - _Have a knife.rb_: add these lines to your knife.rb:

        # your organization name
        organization   '{organization}' 
        # path to your cluster definitions:
        cluster_path   [ "#{/path/to/your/homebase}/clusters" ]

5. You should now be able to `knife cluster list`, to see all the clusters available:

        $ knife cluster list
        +--------------------+-------------------------------------------+
        | cluster            | path                                      |
        +--------------------+-------------------------------------------+
        | burninator         | /cloud/clusters/burninator.rb             |
        | el_ridiculoso      | /cloud/clusters/el_ridiculoso.rb          |
        | elasticsearch_demo | /cloud/clusters/elasticsearch_demo.rb     |
        | hadoop_demo        | /cloud/clusters/hadoop_demo.rb            |
        | sandbox            | /cloud/clusters/sandbox.rb                |
        +--------------------+-------------------------------------------+

   If that doesn't work -- if it instead gives you a way-too-long list of knife commands -- then knife did not find the ironfan plugins. Check [HEY SELENE PLEASE LINK TO KNIFE PLUGINS ON CHEF WIKI] for more.

6. Launching a cluster in the cloud should now be this easy!

        knife cluster launch sandbox:simple --bootstrap

### Next

The README file in each of the subdirectories for more information about what goes in those directories. But you are probably bored of reading. Go customize one of the files in the clusters/ directory. Or, if you're a fan of ridiculous things and have ever wondered how many things you can fit on one box, launch `el_ridiculoso`:

        knife cluster launch el_ridiculoso:grande --bootstrap


Ironfan Homebase Layout
=========================

Chef Homebase contains several directories, and each contains a README.md file describing its purpose and use in greater detail.

These are the main assets you'll use:

* `cookbooks/`  - Cookbooks you download or create. Cookbooks install components, for example `cassandra` or `java`.
* `roles/`      - Roles organize cookbooks and attribute overrides to describe the specific composition of your system. For example, you install Cassandra attaching the `cassandra_server` role to your machine. (.rb or .json files)
* `clusters/`   - Clusters fully describe your machines, from its construction ('an 8-core machine on the Amazon EC2 cloud') to its roles ('install Cassandra, Ganglia for monitoring, and metachef to manage its logs and firewall').

These folders hold supporting files. You're less likely to visit here regularly.

* `knife/`        - Chef and cloud configuration and their myriad attendant credential files.
* `environments/` - Organization-wide attribute values. (.json or .rb files)
* `data_bags/`    - Data bags are an occasionally-useful alternative to node metadata for distributing information to your machines. (.json files)
* `certificates/` - SSL certificates generated by `rake ssl_cert` live here.
* `tasks/`        - Rake tasks for common administrative tasks.
* `vendor/`       - cookbooks are checked out to `vendor`; symlinks in the `cookbooks/` directory select which ones will be deployed to chef server.

You may also wish to explore

* `ironfan-ci/` - Use VMs locally on your desktop to develop and test your clusters before deploying them.

Cookbook Versioning and Tracking
================================

This homebase groups all the repos we use, and is most 

* every cookbook has its own repo on [infochimps-cookbooks' github](http://github.com/infochimps-cookbooks) 
* They are all git-subtree'd into [this repo](http://github.com/infochimps-labs/ironfan-homebase): 
  - infochimps-maintained cookbooks: git-subtree from the infochimps-cookbooks home, placed in `vendor/infochimps`.
  - Other cookbooks: git-subtree from the infochimps-cookbooks fork, placed in `vendor/{original_author}`
  - Opscode community cookboks: *git submodule* of the [infochimps-labs](http://github.com/infochimps-labs/opscode_cookbooks) fork of opscode/cookbooks is into `vendor/opscode`. This holds *all* their cookbooks.
* The actual collection we use is defined by symlinks in `cookbooks/foo` to `../vendor/whatever/foo`. This is everything in vendor/infochimps, vendor/{other}, and the curated subset of things in vendor/opscode.
* Each cookbook's history is present in its solo repo as far back as the may 2011 re-org. However, that history shows up weird in the homebase -- this is a limitation in git that we can't work around.

We welcome pull requests against either homebase or the individual repo. Please only file issues at the [ironfan](https://github.com/infochimps/ironfan/issues) bug tracker though.

Rake Tasks
==========

The homebase contains a `Rakefile` that includes tasks that are installed with the Chef libraries. To view the tasks available with in the homebase with a brief description, run `rake -T`.

Besides your `~/.chef/knife.rb` file, the Rakefile loads `config/rake.rb`, which sets:

* Constants used in the `ssl_cert` task for creating the certificates.
* Constants that set the directory locations used in various tasks.

If you use the `ssl_cert` task, change the values in the `config/rake.rb` file appropriately. These values were also used in the `new_cookbook` task, but that task is replaced by the `knife cookbook create` command which can be configured below.

The default task (`default`) is run when executing `rake` with no arguments. It will call the task `test_cookbooks`.

The following standard chef tasks are typically accomplished using the rake file:

* `bundle_cookbook[cookbook]` - Creates cookbook tarballs in the `pkgs/` dir.
* `install` - Calls `update`, `roles` and `upload_cookbooks` Rake tasks.
* `ssl_cert` - Create self-signed SSL certificates in `certificates/` dir.
* `update` - Update the homebase from source control server, understands git and svn.
* `roles` - iterates over the roles and uploads with `knife role from file`.

Most other tasks use knife: run a bare `knife cluster`, `knife cookbook` (etc) to find out more.

