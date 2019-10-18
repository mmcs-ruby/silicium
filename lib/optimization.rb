require "silicium"

module Silicium
  module Optimization

    # reflector function
    def re_lu(x)
      x.negative? ? 0 : x
    end

    #sigmoid function
    def sigmoid(x)
      1/(1+Math.exp(-x))
    end

  end
end
