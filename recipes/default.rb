#
# Cookbook Name:: shovey-jobs
# Recipe:: default
#
# Copyright 2014, Jeremy Bingham
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'golang'

golang_package node['schob']['package'] do
  action :install
end

directory "/etc/schob" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

directory node['schob']['log_dir'] do 
  owner "root"
  group "root"
  mode "0700"
  action :create
end

init_location = nil
init_source = nil
do_restart = false

case node.platform
when "fedora", "arch"
  init_location = "/lib/systemd/system/schob.service"
  init_source = "schob.service.erb"
  do_restart = true
when "mac_os_x"
  init_location = "/Library/LaunchDaemons/schob.plist"
  init_source = "schob.plist.erb"
when "ubuntu"
  init_location = "/etc/init/schob.conf"
  init_source = "schob.conf-upstart-1.5.erb"
when "centos"
  case node.platform_version.to_i
  when 7
    init_location = "/lib/systemd/system/schob.service"
    init_source = "schob.service.erb"
    do_restart = true
  when 6
    init_location = "/etc/init/schob.conf"
    init_source = "goiardi.conf-upstart-0.6.5.erb"
  else
    init_location = "/etc/init.d/schob"
    init_source = "schob-sysv-init.erb"
    do_restart = true
  end
else
  # current Debians, maybe Solaris?
  init_location = "/etc/init.d/schob"
  init_source = "schob-sysv-init.erb"
  do_restart = true
end

template init_location do
  source init_source
  owner "root"
  group "root"
  mode "0755"
  variables(
    :schob_path => node['schob']['path']
  )
end

cookbook_file "/etc/default/schob" do
  source "schob"
  owner "root"
  group "root"
  mode "0644"
  only_if { init_location == "/etc/init.d/schob" }
end

service "schob" do 
  service_name "schob"
  supports :restart => true, :reload => do_restart
  action [:enable, :start]
end

pem_content = Chef::EncryptedDataBagItem.load(node['schob']['pem_databag'], node['schob']['pem_server'])['key']

file "/etc/schob/shovey.pem" do
  owner "root"
  group "root"
  mode "0600"
  content pem_content
end

template "/etc/schob/schob.conf" do
  owner "root"
  group "root"
  mode "0644"
  variables(
    :goiardi_server => node['schob']['goiardi_server'],
    :client_name => node.name,
    :client_key => node['schob']['client_key'],
    :log_level => node['schob']['log_level'],
    :log_file => node['schob']['log_file'],
    :syslog => node['schob']['syslog'],
    :whitelist_file => "/etc/schob/whitelist.json",
    :shovey_pem => "/etc/schob/shovey.pem",
    :run_timeout => node['schob']['run_timeout'],
    :serf_addr => node['schob']['serf_addr'],
    :queue_save_file => node['schob']['queue_save_file'],
    :time_slew => node['schob']['time_slew']
  )
  notifies :restart, resources(:service => "schob")
end

whitelist = {}
whitelist["whitelist"] = node["schob"]["whitelist"]
file "/etc/schob/whitelist.json" do
  owner "root"
  group "root"
  mode "0600"
  content whitelist.to_json
  notifies :reload, resources(:service => "schob")
end

