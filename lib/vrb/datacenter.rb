# Vrb::Datacenter
#
module Vrb
  class Datacenter < VrbObject
    #TODO pad this class out with info about a Datacenter
    attr_reader :mob, :parent_mob

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
    end

    def vm(name)
      vm_mob = @mob.find_vm(name) or fail "vm not found"
      VM.new(@mob, vm_mob)
    end
  end
end
