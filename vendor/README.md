## vendor/ -- actual checkouts of cookbooks &c

* `infochimps/` - cookbooks maintained by infochimps (either originated us or heavily modified)
* `opscode/`    - the opscode community cookbooks collection. By default a git submodule checkout of http://github.com/infochimps-labs/opscode-cookbooks. This repo tracks the opscode repo but has some relevant fixes applied.

All of the cookbooks you see here are those infochimps uses in production at time of commit. After doing a `git submodule update --init`, you can check out your own fork and git will magically track that instead.
