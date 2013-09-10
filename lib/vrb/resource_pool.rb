# Vrb::ResourcePool
#
module Vrb
  class ResourcePool < VrbObject
    #TODO pad this class out with info about a ResourcePool
    #
    attr_reader :mob, :parent_mob

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
    end
  end
end
