#!/usr/bin/env ruby

require 'vrb'

opts = {
  :template       => 'Bulletproof/Templates/Bx - Ubuntu 12.04 LTS x64 - VMv8 - v1.0',
  :idc            => 'B0',
  :cluster        => 'B0',
  :resource_pool  => 'Staging',
  :serviceid      => 'mp-dvmh-vrb-02',
  :ram            => 8192,
  :cpu            => 8,
  :poweron        => false,
  :isatemplate    => false,
  :wait           => true
}


# connect to vcenter using ~/.fog for creds
vc = Vrb::Vcenter.new

datacenter    = vc.datacenter(opts[:idc])
cluster       = datacenter.cluster(opts[:cluster])
resource_pool = cluster.resource_pool(opts[:resource_pool])
template      = datacenter.vm(opts[:template])
dst_dir       = template.mob.parent #FIXME: add method to Vrb::Datacenter? for locating a folder object


puts "cloning #{template.serviceid} to #{dst_dir.name}/#{opts[:serviceid]}"
template.clone(dst_dir, resource_pool, opts)
puts "done"

