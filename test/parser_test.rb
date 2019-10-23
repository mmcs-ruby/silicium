require "test_helper"

require 'parser'

class ParserTest<Minitest::Test
  include Silicium
  def test_polycop
    p = Silicium::Polynom.('x**2 + 1')
    puts p.evaluate 1
    assert(polycop('x^2 + 2 * x + 7'))
    assert(!polycop('eval(exit)'))
    assert(!polycop('x^2 +2nbbbbb * x + 7'))
    assert(polycop('x**4 + 1'))
    assert(polycop('(3*x)x***4 + 1'))
    assert(!polycop('x*b4 + 1'))
    assert(!polycop('3*x^4 - 2*x^3 + 7y - 1'))
    assert(polycop('sin(x) + 1'))

  end
end