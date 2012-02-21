# Ironfan Homebase: Master Plans for a Scalable Architecture

The Infochimps Ironfan project is an expressive toolset for constructing scalable, resilient architectures. It works in the cloud, in the data center, and on your laptop, and it makes your system diagram visible and inevitable. Inevitable systems coordinate automatically to interconnect, removing the hassle of manual configuration of connection points (and the associated danger of human error).

The Ironfan Homebase repository is the central home for orchestrating your architecture. It unifies:
	
* cookbooks, roles, and environments
* cluster descriptions
* your Chef and cloud credentials
* pantries (collections of cookbooks, roles and so forth)

To get started with Ironfan, clone the [ironfan-homebase repo](https://github.com/infochimps-labs/ironfan-homebase) and follow the [installation instructions](https://github.com/infochimps-labs/ironfan/wiki/install). Please file all issues on [Ironfan issues](https://github.com/infochimps-labs/ironfan/issues).

## Index

ironfan-homebase works together with the full Ironfan toolset:

* [ironfan-homebase](https://github.com/infochimps-labs/ironfan-homebase): Centralizes the cookbooks, roles and clusters. A solid foundation for any chef user.
* [ironfan gem](https://github.com/infochimps-labs/ironfan): The core Ironfan models, and Knife plugins to orchestrate machines and coordinate truth among your homebase, cloud and chef server.
* [ironfan-pantry](https://github.com/infochimps-labs/ironfan-pantry): Our collection of industrial-strength, cloud-ready recipes for Hadoop, HBase, Cassandra, Elasticsearch, Zabbix and more.
* [silverware cookbook](https://github.com/infochimps-labs/ironfan-pantry/tree/master/cookbooks/silverware): Helps you coordinate discovery of services ("list all the machines for `awesome_webapp`, that I might load balance them") and aspects ("list all components that write logs, that I might logrotate them, or that I might monitor the free space on their volumes").
* [ironfan-ci](https://github.com/infochimps-labs/ironfan-ci): Continuous integration testing of not just your cookbooks, but of your *architecture* as well.  Fancy huh? 
* [ironfan wiki](https://github.com/infochimps-labs/ironfan/wiki): High-level documentation and install instructions.
* [ironfan issues](https://github.com/infochimps-labs/ironfan/issues): Bugs or questions and feature requests for *any* part of the Ironfan toolset.
* [ironfan gem docs](http://rdoc.info/gems/ironfan): Rdoc docs for Ironfan

__________________________________________________________________________

## Getting started

Before you start, fork this repo, as you'll be personalizing it for your use.

Clone the repo and all of its submodules:

        git clone https://github.com/infochimps-labs/ironfan-homebase homebase
        cd homebase
		git submodule foreach git checkout master
        git submodule update --init

Now follow the detailed install notes in [`homebase/notes/INSTALL.md`](https://github.com/infochimps-labs/ironfan/wiki/install).

In the Install notes you'll notice the Git clone instructions again, we just want to make sure you're on the right track.   	 	