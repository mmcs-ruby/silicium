require "silicium"

module Silicium
  module Optimization

    # reflector function
    def re_lu(x)
      x.negative? ? 0 : x
    end
  end

end
