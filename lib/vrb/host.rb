# Vrb::Host
#
module Vrb
  class Host < VrbObject
    #TODO pad this class out with info about a Host
    #
    attr_reader :mob, :parent_mob

    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
    end
  end
end
