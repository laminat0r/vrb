# Vrb::Cluster
#
module Vrb
  class Cluster < VrbObject
    #TODO pad this class out with info about a Cluster
    attr_reader :mob, :parent_mob

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
    end

    def resource_pools(return_as_mobs = true)
      mobs = @mob.resourcePool.resourcePool
      if return_as_mobs == true
        mobs
      else
        mobs.collect { |mob| mob.name }
      end
    end

    def resource_pool(name)
      mobs = self.resource_pools
      rp_mob = mobs.select { |mob| mob.name =~ /#{name}/ }.first or fail "Sorry!"
      ResourcePool.new(@mob,rp_mob)
    end
  end
end
