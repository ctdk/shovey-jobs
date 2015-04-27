name             'shovey-jobs'
maintainer       'Jeremy Bingham'
maintainer_email 'jeremy@goiardi.gl'
license          'Apache 2.0'
description      'Installs/Configures shovey-jobs'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.3'
depends "serf", '~> 0.9.0'
depends "golang", '~> 1.5.0'
supports "debian"
supports "centos"
supports "ubuntu"

attribute "schob",
  :display_name => "schob attributes",
  :description => "Attributes for the shovey client",
  :type => "hash"

attribute "schob/goiardi_server",
  :display_name => "schob goiardi server",
  :description => "URL for the goiardi server that issues shovey jobs."

attribute "schob/path",
  :display_name => "path",
  :description => "The path to the directory the schob binary will be installed.",
  :default => "/opt/go/bin"

attribute "schob/package",
  :display_name => "schob package repo",
  :description => "The repository to get schob from to install.",
  :default => "github.com/ctdk/schob"

attribute "schob/log_dir",
  :display_name => "schob log dir",
  :description => "The directory to write schob log files.",
  :default => "/var/log/schob"

attribute "schob/log_file",
  :display_name => "schob log file",
  :description => "The schob log file.",
  :default => "/var/log/schob/schob.log"

attribute "schob/syslog",
  :display_name => "schob syslog",
  :description => "If set to true, schob will log to syslog rather than a file.",
  :default => false

attribute "schob/log_level",
  :display_name => "schob log level",
  :description => "Verbosity of logging. Available options are 'debug', 'info', 'warning', 'error', and 'critical', default is 'info'.",
  :default => "info"

attribute "schob/shovey_pem",
  :display_name => "schob shovey pem",
  :description => "Path to where the shovey public key will be installed",
  :default => "/etc/schob/shovey.pem"

attribute "schob/pem_databag",
  :display_name => "schob pem databag",
  :description => "Encrypted data bag holding the public key.",
  :default => "shovey_keys"

attribute "schob/pem_server",
  :display_name => "schob pem server",
  :description => "Data bag item name that has the public key."

attribute "schob/serf_addr",
  :display_name => "schob serf addr",
  :description => "RPC client address of this node's serf agent. The serf agent's name must be the same as the chef node's name.",
  :default => "127.0.0.1:7373"

attribute "schob/client_key",
  :display_name => "schob client key",
  :description => "Path to the chef client key.",
  :default => "/etc/chef/client.rb"

attribute "schob/run_timeout",
  :display_name => "schob run timeout",
  :description => "How long to wait, in minutes, before killing a shovey job that's running. Defaults to 45 minutes.",
  :default => "45"

attribute "schob/time_slew",
  :display_name => "schob time slew",
  :description => "Time difference allowed between the node's clock and the time sent in the serf command from the server.  Formatted like 5m, 150s, etc. Defaults to 15m.",
  :default => "15m"

attribute "schob/whitelist",
  :display_name => "schob whitelist",
  :description => "Hash of names and commands of jobs to allow to be run on this node.",
  :type => "hash",
  :default => { "chef-client" => "chef-client" }

attribute "schob/queue_save_file",
  :display_name => "schob queue save file",
  :description => "If set, jobs will be written to and removed from this file as they are added and finished. If schob is suddenly interrupted it will replay this file and send reports back to goiardi that some jobs did not complete because the client died."
