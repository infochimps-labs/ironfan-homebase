# Ironfan Homebase: master plans for a scalable architecture

The ironfan project is an expressive toolset for constructing scalable, resilient architectures. It works in the cloud, in the data center, and on your laptop, and makes your system diagram visible and inevitable.

This repo is the central home for orchestrating your architecture. It unifies

* cookbooks, roles and environments
* cluster descriptions
* your chef and cloud credentials
* pantries (collections of cookbooks, roles and so forth)

To get started with ironfan, clone the [homebase repo](https://github.com/infochimps-labs/ironfan-homebase) and follow the [installation instructions](https://github.com/infochimps-labs/ironfan/wiki/install). Please file all issues on [ironfan issues](https://github.com/infochimps-labs/ironfan/issues).

## Index

ironfan-homebase works together with the full ironfan toolset:

* [ironfan-homebase](https://github.com/infochimps-labs/ironfan-homebase): centralizes the cookbooks, roles and clusters. A solid foundation for any chef user.
* [ironfan gem](https://github.com/infochimps-labs/ironfan): core ironfan models, and knife plugins to orchestrate machines and coordinate truth among you homebase, cloud and chef server.
* [ironfan-pantry](https://github.com/infochimps-labs/ironfan-pantry): Our collection of industrial-strength, cloud-ready recipes for Hadoop, HBase, Cassandra, Elasticsearch, Zabbix and more.
* [silverware cookbook](https://github.com/infochimps-labs/ironfan-homebase/tree/master/cookbooks/silverware): coordinate discovery of services ("list all the machines for `awesome_webapp`, that I might load balance them") and aspects ("list all components that write logs, that I might logrotate them, or that I might monitor the free space on their volumes".
* [ironfan-ci](https://github.com/infochimps-labs/ironfan-ci): Continuous integration testing of not just your cookbooks but your *architecture*.

* [ironfan wiki](https://github.com/infochimps-labs/ironfan/wiki): high-level documentation and install instructions
* [ironfan issues](https://github.com/infochimps-labs/ironfan/issues): bugs, questions and feature requests for *any* part of the ironfan toolset.
* [ironfan gem docs](http://rdoc.info/gems/ironfan): rdoc docs for ironfan

__________________________________________________________________________

## Getting started

Before you start, you may wish to fork this repo, as you'll be personalizing it for your use.

Clone the repo and all its submodules:

        git clone https://github.com/infochimps-labs/ironfan-homebase homebase
        cd homebase
        git submodule update --init

Now follow the detailed install notes in [`homebase/notes/INSTALL.md`](https://github.com/infochimps-labs/ironfan/wiki/install).
