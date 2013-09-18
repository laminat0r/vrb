## Vrb::VM
#
module Vrb
  class VM < VrbObject

    attr_reader :mob, :tools_status, :os, :ip, :host, :is_a_template, :nics, :serviceid, :ram, :cpu, :state

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
      @nics = list_nics
      begin
        @serviceid      = @mob.name
        @tools_status   = @mob.guest.toolsStatus
        @cpu            = @mob.config.hardware.numCPU
        @ram            = @mob.config.hardware.memoryMB
        @os             = @mob.summary.guest.guestFullName
        @ip             = @mob.guest.ipAddress
        @host           = @mob.runtime.host.name
        @is_a_template  = @mob.summary.config.template
        @state          = @mob.guest.guestState
      rescue
        @os             = nil
        @ip             = nil
        @host           = nil
        @is_a_template  = nil
      end
    end

    def ram=(new_ram)
      fail "memory must be a multiple of 4MB" unless ( new_ram % 4 ) == 0
      fail "VM needs to be off" unless vm.summary.runtime.powerState == 'poweredOff'
      fail "VM already has #{new_ram} amount of ram" if new_ram == @ram
      spec = { :memoryMB => new_ram }
      @mob.ReconfigVM_Task(:spec => spec).wait_for_completion
    end

    def cpu=(new_cpu)
      fail "VM already has #{new_cpu} CPUs" if new_cpu == @cpu
      spec = { :numCPUs => new_cpu }
      @mob.ReconfigVM_Task(:spec => spec).wait_for_completion
    end

    def off!
      fail "Um...VM needs to be on first." unless vm.summary.runtime.powerState == 'poweredOn'
      @mob.PowerOffVM_Task.wait_for_completion
    end

    def on!
      fail "Um...VM needs to be off first." unless vm.summary.runtime.powerState == 'poweredOff'
      @mob.PowerOnVM_Task.wait_for_completion
    end

    def reboot!
      fail "Um...VM needs to be on first." unless vm.summary.runtime.powerState == 'poweredOn'
      fail "vm tools not installed or not running" unless @tools_status == 'toolsOk'
      @mob.RebootGuest.wait_for_completion
    end

    def shutdown!
      fail "Um...VM needs to be on first." unless vm.summary.runtime.powerState == 'poweredOn'
      fail "vm tools not installed or not running" unless @tools_status == 'toolsOk'
      @mob.ShutdownGuest.wait_for_completion
    end

    def reset!
      fail "Um...VM needs to be on first." unless vm.summary.runtime.powerState == 'poweredOn'
      @mob.ResetVM_Task.wait_for_completion
    end

    def clone(dst_dir, rp, opts={})
      config_spec           = RbVmomi::VIM::VirtualMachineConfigSpec()
      config_spec.numCPUs   = opts[:cpu]
      config_spec.memoryMB  = opts[:ram]

      relocation_spec       = RbVmomi::VIM.VirtualMachineRelocateSpec
      relocation_spec.pool  = rp.mob

      clone_spec            = RbVmomi::VIM.VirtualMachineCloneSpec
      clone_spec.location   = relocation_spec
      clone_spec.config     = config_spec
      clone_spec.powerOn    = opts[:poweron]
      clone_spec.template   = opts[:isaitemplate]

      task = @mob.CloneVM_Task(:folder => opts[:dst_dir], :name => opts[:serviceid], :spec => clone_spec)
      if opts[:wait]
        task.wait_for_completion
      else
        task
      end
    end

    private

    def list_nics
      nics = []
      nic_mobs = @mob.config.hardware.device.select do |n|
        n.deviceInfo.label =~ /Network\ adapter/
      end
      nic_mobs.each do |n|
        # if the nic is on a dvSwitch, we have to go to it to find the name of the port group
        if n.backing.class.to_s =~ /VirtualEthernetCardDistributedVirtualPortBackingInfo/
          pgs = @mob.runtime.host.network.grep(VIM::DistributedVirtualPortgroup)
          network = pgs.find { |p| p.key == n.backing.port.portgroupKey }
          dvswitch = pgs.collect { |p| p.config.distributedVirtualSwitch }
        end

        nic_name = n.deviceInfo.label
        nic_friendly_name = nic_name.sub(/Network\ adapter\s+/, '').to_i

        nics[nic_friendly_name] = {
          :name => nic_name,
          :network_name => network.name,
          :network_mob => network,
          :nic_mob => n,
          :dvswitch => dvswitch,
          :is_connected => n.connectable.connected
        }
        nics
      end
    end
  end
end
