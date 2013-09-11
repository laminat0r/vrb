#!/usr/bin/env ruby


require 'vrb'

vc = Vrb::Vcenter.new
dc = vc.get_datacenter('B0') # can be long or short form - something that is unique
vm = dc.get_vm('Bulletproof/Templates/Bx - Ubuntu 12.04 LTS x64 - VMv8 - v1.0')


puts "--- SERVICEID:  #{vm.serviceid} ---"
puts "--- CPU:        #{vm.cpu} ---"
puts "--- RAM:        #{vm.ram} ---"
puts "--- Annotation: #{vm.mob.summary.config.annotation} ---"
puts "--- Template:   #{vm.is_a_template} ---"
puts "--- Host:       #{vm.host} ---"
puts "--- IP:         #{vm.ip} ---"
puts "--- OS:         #{vm.os} ---"

