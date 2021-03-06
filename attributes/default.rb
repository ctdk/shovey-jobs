default["schob"]["path"] = "/opt/go/bin"
default["schob"]["package"] = "github.com/ctdk/schob"
default["schob"]["log_dir"] = "/var/log/schob"
default["schob"]["log_file"] = "/var/log/schob/schob.log"
default["schob"]["syslog"] = false
default["schob"]["log_level"] = "info"
default["schob"]["shovey_pem"] = "/etc/schob/shovey.pem"
default["schob"]["pem_databag"] = "shovey_keys"
default["schob"]["serf_addr"] = "127.0.0.1:7373"
default["schob"]["client_key"] = "/etc/chef/client.pem"
default["schob"]["run_timeout"] = 45
default["schob"]["whitelist"] = { "chef-client" => "chef-client" }
default["schob"]["time_slew"] = "15m"
