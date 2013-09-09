#!/usr/bin/env ruby


require 'vrb'

datacenter  = 'B0'
vm_name     = 'Bulletproof/Templates/Bx - Ubuntu 12.04 LTS x64 - VMv8 - v1.0'

vc = Vrb::Vcenter.new
dc = vc.get_datacenter(datacenter)

vm = dc.get_vm(vm_name)

# the Vm object has a sensible set of default data and methods available but you have access to the underlying 
# rbvmomi object should you want it - vm.mob.***

puts "--- Name:     #{vm_name} ---"
puts "--- Template: #{vm.is_a_template} ---"
puts "--- OS:         #{vm.mob.summary.config.guestFullName} ---"
puts "--- CPU:        #{vm.mob.summary.config.numCpu} ---"
puts "--- RAM:        #{vm.mob.summary.config.memorySizeMB} ---"
puts "--- Annotation: #{vm.mob.summary.config.annotation} ---"

