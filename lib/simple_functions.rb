require "silicium"

module Silicium
  #reflector function
  def reLu(x)
    return 0 if x < 0
    x
  end
end
