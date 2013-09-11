## Vrb::VM
#
module Vrb
  class VM < VrbObject

    attr_reader :mob, :tools_status, :os, :ip, :host, :is_a_template, :nics, :serviceid, :ram, :cpu

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
      rescue
        @os             = nil
        @ip             = nil
        @host           = nil
        @is_a_template  = nil
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
