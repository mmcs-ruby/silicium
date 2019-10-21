require "silicium/version"

module Silicium
  class Geometry

	Point = Struct.new(:x, :y)
    Point3d = Struct.new(:x,:y,:z)
	
	#введём вспомогательную функцию upd\_ans(), которая будет вычислять расстояние 
	#между двумя точками и проверять, не лучше ли это текущего ответа
	def upd_ans (a, b) {
	dist = sqrt ((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y) + .0);
	if (dist < mindist)
		mindist = dist
		ansa = a
		ansb = b;
	}
	
	#
	#
  end
  # Your code goes here...
end