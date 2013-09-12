#!/usr/bin/env ruby

require 'vrb'

## currently uses creds from ~/.fog
#
vc = Vrb::Vcenter.new

#

dc = vc.datacenter('B0') # can be long or short form - something that is unique
vm = dc.vm('Testing/MP/mp-dvmh-bootstraptest-01')
vm.off!

## can also chain all together
#
vc.datacenter('B0').vm('Testing/MP/mp-dvmh-bootstraptest-01').off!


