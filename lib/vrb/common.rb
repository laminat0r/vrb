module Vrb

  class VrbObject
    def initialize(parent_mob, self_mob)
      @mob = self_mob
      @parent_mob = parent_mob
    end

    def inspect
      "#{self.class}(#{@mob.name})"
    end
  end

end
