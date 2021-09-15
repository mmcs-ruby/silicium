require 'silicium/version'

module Silicium
  class Error < StandardError; end

  require_relative 'geometry'
  require_relative 'graph'

  
  require_relative 'algebra'
  require_relative 'algebra_diff'
  require_relative './geometry'
  require_relative 'geometry3d'
  require_relative './graph'
  require_relative 'graph_visualizer'
  require_relative 'ml_algorithms'
  require_relative 'numerical_integration'
  require_relative 'optimization'
  require_relative 'plotter'
  require_relative 'polynomial_division'
  require_relative 'polynomial_interpolation'
  require_relative 'regression'
  require_relative 'theory_of_probability'
  require_relative 'topological_sort'
  require_relative 'silicium/sparse'
  


end
