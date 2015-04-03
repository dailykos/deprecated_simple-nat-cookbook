#
# Cookbook Name:: simple-nat-cookbook
# Recipe:: default
#
# Copyright (C) 2015 dailykos
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'iptables-ng::default'
include_recipe 'sysctl::default'

iptables_ng_rule 'simple_nat_router' do
  ip_version 4
  table      'nat'
  chain      'POSTROUTING'
  rule       '-j MASQUERADE'
end

sysctl_param 'net.ipv4.ip_forward' do
  value 1
end
