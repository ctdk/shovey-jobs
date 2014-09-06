shovey-jobs Cookbook
====================
A cookbook to install schob, the client for running goiardi's shovey jobs. It's
like Chef's push jobs, but serf based and works with goiardi. It is still in
development, but is close enough to completion to have this cookbook for
installing shovey as a preview.

Requirements
------------
Requires goiardi of recent enough vintage that it has shovey. Currently that
means the tip of the 'serfing' branch in the github repo. As of this writing,
only the in-memory data store works with shovey.

Also, to actually issue shovey jobs the knife-shove plugin (at 
https://github.com/ctdk/knife-shove) is required on the workstation you'll be
managing shovey from.

- serf cookbook
- golang cookbook

Platforms
---------
At the moment this cookbook is only known to work on Debian. It may work on 
Ubuntu, but the init script it installs is adapted from Debian's skeleton init
script.

Attributes
----------

`node["schob"]["goiardi_server"]` The URL to the goiardi server. 

`node["schob"]["path"]` The path to the directory the schob binary will be 
 installed.

`node["schob"]["package"]` The repository for schob.

`node["schob"]["log_dir"]` The log file directory.

`node["schob"]["log_file"]` The full path to the log file

`node["schob"]["syslog"]` If true, schob will log to syslog instead of a file.

`node["schob"]["log_level"]` Verbosity of logging. Available options are
 'debug', 'info', 'warning', 'error', and 'critical', default is 'info'.

`node["schob"]["shovey_pem"]` Path to where the shovey public key will be
 installed.

`node["schob"]["pem_databag"]` Encrypted data bag holding the public key.

`node["schob"]["pem_server"]` Data bag item name that has the public key.

`node["schob"]["serf_addr"]` RPC client address of this node's serf agent. The
 serf agent's name must be the same as the chef node's name.

`node["schob"]["client_key"]` Path to the chef client key.

`node["schob"]["run_timeout"]` How long to wait, in minutes, before killing a 
 shovey job that's running. Defaults to 45 minutes.

`node["schob"]["whitelist"]` Hash of names and commands of jobs to allow to be
 run on this node.

`node["schob"]["queue_save_file"]` If set, jobs will be written to and removed
 from this file as they are added and finished. If schob is suddenly interrupted
 it will replay this file and send reports back to goiardi that some jobs did
 not complete because the client died.

`node["schob"]["time_slew"]` Time difference allowed between the node's clock 
 and the time sent in the serf command from the server.  Formatted like 5m, 
 150s, etc. Defaults to 15m.

Usage
-----
#### shovey-jobs::default

Include `shovey-jobs` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[shovey-jobs]"
  ]
}
```

An encrypted data bag (with the default name `shovey_keys`) must be created. In
a data bag item named by `node['schob']['pem_server']` (see below), an attribute
inside the data bag named `key` stores the public key used to verify goiardi
shovey job requests. This would have been set up while installing goiardi with
shovey capabilities.

There are some attributes that *must* be set on your node, one way or another.
`node['schob']['goiardi_server']` must be set to the goiardi server this node
receives jobs from, `node['schob']['client_key']` must be set to the chef client
key if it isn't `/etc/chef/client.rb`, and `node['schob']['pem_server']` must be
set to the name of the data bag item containing the public key part of the 
RSA keypair used by goiardi to sign its job requests. Otherwise, the attributes
have reasonable defaults.

While not mandatory, you may want to add jobs to the whitelist. These are found
in the node attributes, lovingly assembled from the various node, role, and
environment attributes, and dictate what the shovey client will run. By default
it only includes `chef-client`. It is formatted something like this:

```json
{
  ...
  "default_attributes": {
  ...
    "schob": {
      "whitelist": {
      "chef-client":"chef-client",
      "ntp-restart":"/etc/init.d/ntp restart",
      "ls": "ls /"
      }
    }
  }
}
```

... where the hash key is the name of the command, and the value is the command
to run.

Assuming the cookbook runs and installs everything correctly (serf,
particularly, will probably require extra configuration options that are 
site-specific), you'll be ready to start running jobs against your node or
nodes. Refer to the `knife-shove` documentation on how to use shovey.

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Author: Jeremy Bingham <jbingham@gmail.com>
