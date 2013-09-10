## Vrb::VM
#
module Vrb
  class VM < VrbObject

    attr_reader :mob, :tools_status, :os, :ip, :host, :is_a_template, :nics

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
      @nics = list_nics
      begin
        @tools_status = @mob.guest.toolsStatus
        @os = @mob.summary.guest.guestFullName
        @ip = @mob.guest.ipAddress
        @host = @mob.runtime.host.name
        @is_a_template = @mob.summary.config.template
      rescue
        @os = nil
        @ip = nil
        @host = nil
        @is_a_template = nil
      end
    end
  end
end
