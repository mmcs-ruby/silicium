require "silicium/version"

module Silicium
  class Geometry

		##
		# Represents a point as two coordinates
		# in two-dimensional space
		Point = Struct.new(:x, :y)
		Point3d = Struct.new(:x,:y,:z)

		def distance_point_to_point2d(a,b)
			Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2)
		end

		def distance_point_to_point3d(a,b)
			Math.sqrt((b.x-a.x)**2+(b.y-a.y)**2+(b.z-a.z)**2)
		end

		# Needed to sort array of points
		# according to X coordinate
		def compare_X(a, b)
			a.x -b.x
		end
		def compare_Y(a,b)
			a.y - b.y
		end

		# A Brute Force method to return the
		# smallest distance between two points
		# in P[]
		def brute_force_method(points)
			min = distance_point_to_point2d(points[i], points[i+1])
			points.each { |i|
				if (distance_point_to_point2d(points[i], points[i + 1]) < min)
					min = distance_point_to_point2d(points[i], points[i + 1])
				end
			}
		end

		# A recursive function to find the
		# smallest distance. The array P contains
		# all points sorted according to x coordinate
		def closest_points(points, n = points.size)
			# If there are 2 or 3 points, then use brute force
			if (points.size <= 3)
				return brute_force_method(points)
			end

			# Find the middle point
			mid = points.size / 2
			mid_Point = points[mid]

			# recursion to the left and to the right
			dl = closest_points(points[mid])
			dr = closest_points(points[n + mid], n - mid)

			# Find the smaller of two distances
			d = [dl, dr].min()

			# Build an array strip[] that contains
			# points close (closer than d)
			# to the line passing through the middle point


			end

	end
  # Your code goes here...
end