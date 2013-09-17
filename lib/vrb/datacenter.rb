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

    def clusters(return_as_mobs = true)
      mobs = @mob.hostFolder.children.grep(VIM::ClusterComputeResource)
      if return_as_mobs == true
        mobs
      else
        mobs.collect { |mob| mob.name }
      end
    end

    def cluster(name)
      mobs = self.clusters
      cl_mob = mobs.select { |mob| mob.name =~ /#{name}/ }.first or fail "Sorry!"
      Cluster.new(@mob, cl_mob)
    end
  end
end
